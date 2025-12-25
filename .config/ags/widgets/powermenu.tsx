import { Gtk } from "astal/gtk3";
import { execAsync } from "astal/process";
import { Variable, bind } from "astal";

const menuOpen = new Variable(false);

function closeMenu() {
  menuOpen.set(false);
}

export function PowerMenu() {
  return (
    <box spacing={4} hexpand halign={Gtk.Align.END}>
      {bind(menuOpen).as((open) =>
        open ? (
          <box spacing={4} className="power-menu">
            <button
              className="menu-item logout"
              onClicked={() => {
                closeMenu();
                execAsync(["systemctl", "--user", "stop", "graphical-session.target"]).catch(() => {});
              }}
            >
              <label label="Logout" />
            </button>
            <button
              className="menu-item suspend"
              onClicked={() => {
                closeMenu();
                execAsync(["systemctl", "suspend"]).catch(() => {});
              }}
            >
              <label label="Suspend" />
            </button>
            <button
              className="menu-item reboot"
              onClicked={() => {
                closeMenu();
                execAsync(["systemctl", "reboot"]).catch(() => {});
              }}
            >
              <label label="Reboot" />
            </button>
            <button
              className="menu-item shutdown"
              onClicked={() => {
                closeMenu();
                execAsync(["systemctl", "poweroff"]).catch(() => {});
              }}
            >
              <label label="Shutdown" />
            </button>
          </box>
        ) : (
          <box />
        )
      )}
      <button
        className="power-button"
        onClicked={() => {
          menuOpen.set(!menuOpen.get());
        }}
      >
        <label label="⏻" />
      </button>
    </box>
  );
}