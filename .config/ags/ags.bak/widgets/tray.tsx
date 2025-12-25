import { Gtk } from "astal/gtk3";

export function SystemTray() {
  return (
    <box spacing={4}>
      <button className="tray-item" onClicked={() => {}}>
        <label label="📋" />
      </button>
    </box>
  );
}
