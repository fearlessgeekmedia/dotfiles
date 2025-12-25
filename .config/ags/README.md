# AGS Bar - Documentation

This is an Astal-based GTK bar for a NixOS desktop environment. The bar is built with Astal (a dynamic GTK framework) and TypeScript/TSX.

## Architecture Overview

The bar consists of three main files and a widgets directory:

- **app.ts**: Application entry point. Initializes the GTK app, applies dark theme, loads CSS styling, and starts the Bar component.
- **bar.tsx**: Main bar layout component. Defines the window geometry, anchoring, and composites all widgets (Left, Center, Right sections).
- **widgets/**: Directory containing individual widget components for different features.
- **style.css**: Stylesheet for the entire bar.

## Bar Layout

The bar is divided into three horizontal sections:

```
[Left: Workspaces, Updates] [---spacer---] [Center: Clock, Weather] [---spacer---] [Right: Audio, Backlight, Battery, Tray, PowerMenu]
```

Each section is a separate component function that returns JSX. The bar window uses `Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT` to span the top of the screen.

## Widget System

Each widget is a separate TSX file in the `widgets/` directory. Widgets:

1. Import necessary utilities from `astal` (bind, Variable, interval, etc.)
2. Export a default or named function that returns JSX (a GTK widget tree)
3. Use `bind()` to create reactive bindings to properties that auto-update the UI
4. Use `Variable` for local state management

### Example Widget Pattern

```typescript
import { bind, Variable } from 'astal';

const myState = new Variable('initial value');

export function MyWidget() {
  return (
    <box>
      <label label={bind(myState)} />
    </box>
  );
}
```

## System Tray Widget (tray.tsx)

### Overview

The system tray is the most complex widget. It displays icons for system applications (Network Manager, Bluetooth, PulseAudio, etc.) and provides menu interaction.

### Key Implementation Details

**1. AstalTray Library**

The tray uses the `astal-tray` library which provides DBus bindings to the system tray protocol. It must be installed and properly configured:

```bash
# In NixOS configuration.nix, add to environment.systemPackages:
astal.tray
```

The GObject introspection typelib needs to be available. If running outside the full NixOS environment, set:
```bash
GI_TYPELIB_PATH="/nix/store/.../astal-tray-0-unstable-.../lib/girepository-1.0:$GI_TYPELIB_PATH"
```

**2. Tray Item Properties**

Each tray item (from `AstalTray.Tray.get_items()`) has:
- `title`: Display name (e.g., "Network", "Bluetooth")
- `icon_name`: Icon identifier for the icon theme
- `is_menu`: Boolean indicating if the item supports a menu
- `menu_model`: GLib.MenuModel for items that support menus
- `action_group`: GioSimpleActionGroup containing the menu actions

**3. Menu Handling - Critical Implementation**

Menu interaction requires three key steps:

1. **Create GTK menu from model**: Use `Gtk.Menu.new_from_model(menuModel)` to create a native GTK menu from the GLib.MenuModel.

2. **Attach action group**: The menu's actions must be connected to the button's action context:
   ```typescript
   btn.insert_action_group('dbusmenu', actionGroup);
   ```
   The prefix **must be 'dbusmenu'** - this is the convention used by DBusMenu protocol.

3. **Attach menu to widget and popup**: Critical step that many implementations miss:
   ```typescript
   gtkMenu.attach_to_widget(btn, null);
   gtkMenu.popup_at_widget(btn, Gdk.Gravity.SOUTH_EAST, Gdk.Gravity.NORTH_WEST, event);
   ```
   Without `attach_to_widget()`, action dispatch fails. The menu needs context of which widget it's attached to.

**4. Event Handling**

Use `on_button_press_event` to handle clicks (both left and right). The event object contains button information and coordinates needed for popup positioning.

### Complete Tray Widget Flow

1. Initialize tray from `AstalTray.Tray.get_default()`
2. Get items list and bind to a Variable for reactivity
3. Connect to 'item-added' and 'item-removed' signals to update the list
4. For each item, render a Button with icon
5. On button press:
   - Get the menu model and action group from the item
   - Insert action group with 'dbusmenu' prefix
   - Create GTK menu from model
   - **Attach menu to button (critical!)**
   - Popup menu with proper gravity and event

### Common Issues

**Menus don't appear**: Make sure `attach_to_widget()` is called before `popup_at_widget()`.

**Menu items not clickable**: Verify the action group was inserted with the correct 'dbusmenu' prefix.

**Network applet menu appears but items not clickable**: This indicates the action group wasn't properly connected. Ensure `insert_action_group('dbusmenu', actionGroup)` was called.

**GI_TYPELIB_PATH errors**: The astal-tray typelib must be in the path. In NixOS, set this in configuration.nix:
```nix
alias ags-run="GI_TYPELIB_PATH=\"${pkgs.astal.tray}/lib/girepository-1.0:\$GI_TYPELIB_PATH\" ags run"
```

## Running the Bar

```bash
# With proper typelib path set (via alias or env var)
ags run

# Or directly with env var
GI_TYPELIB_PATH="/nix/store/.../astal-tray-0-unstable-.../lib/girepository-1.0:$GI_TYPELIB_PATH" ags run
```

## Development Notes

### Binding System

The `bind()` function creates a reactive binding. When the bound property changes, the UI updates automatically:

```typescript
// Simple binding
<label label={bind(myVar)} />

// With transformation
<label label={bind(myVar).as(val => val.toUpperCase())} />

// Binding to object properties
<label label={bind(item, 'property-name')} />
```

### Variable Updates

Variables trigger UI updates when `set()` is called:
```typescript
const myVar = new Variable('initial');
myVar.set('new value'); // Triggers UI update
```

### Astal Widgets

All GTK widgets are accessible via `Widget.*`:
- `Widget.Box`, `Widget.Button`, `Widget.Label`, `Widget.Icon`, etc.
- JSX syntax automatically calls the widget constructors
- Properties are passed as JSX attributes

### GObject Integration

GObject bindings (from astal-tray and other libraries) follow these patterns:
- Properties with hyphens become underscores: `icon-name` → `icon_name`
- Methods are lowercase with underscores: `getMenuModel()` → `get_menu_model()`
- Signals are connected with `.connect('signal-name', callback)`

## Future Improvements

- Consider extracting DBusMenu logic into a utility function for reusability
- Add error handling for missing icons or failed tray operations
- Consider caching menu models to reduce DBus calls
- Add keyboard navigation support for menus

## References

- Astal Framework: https://github.com/Aylur/astal
- GTK4 Documentation (applies to much of GTK3 API)
- GObject Introspection: Used by astal-tray for DBus integration
- DBusMenu Specification: The protocol system trays use for menus
