import { bind, Variable } from 'astal';
import { Gtk, Gdk, Widget } from 'astal/gtk3';
import AstalTray from 'gi://AstalTray';

const items = new Variable([]);

const tray = AstalTray.Tray.get_default();
const initialItems = tray.get_items();
items.set(initialItems || []);
tray.connect('item-added', () => {
    items.set(tray.get_items() || []);
});
tray.connect('item-removed', () => {
    items.set(tray.get_items() || []);
});

const SysTrayItem = (item) => {
    return (
        <Widget.Button
            tooltipMarkup={bind(item, 'title')}
            on_button_press_event={(btn, event) => {
               const menuModel = item.get_menu_model();
               if (menuModel) {
                   const actionGroup = item.get_action_group();
                   // Remove any existing action group first
                   try {
                       btn.remove_action_group('dbusmenu');
                   } catch(e) {}
                   
                   // Insert action group with dbusmenu prefix
                   if (actionGroup) {
                       btn.insert_action_group('dbusmenu', actionGroup);
                   }

                   const gtkMenu = Gtk.Menu.new_from_model(menuModel);
                   gtkMenu.attach_to_widget(btn, null);
                   gtkMenu.popup_at_widget(btn, Gdk.Gravity.SOUTH_EAST, Gdk.Gravity.NORTH_WEST, event);
               } else {
                   // Fallback for items without a standard menu model
                   item.secondary_activate(0, 0); 
               }
               return true;
            }}
        >
            <Widget.Icon icon={bind(item, 'icon_name')} />
        </Widget.Button>
    );
};

export function SystemTray() {
    return (
        <Widget.Box className="tray">
            {bind(items).as(items => items.map(SysTrayItem))}
        </Widget.Box>
    );
}
