import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { execAsync } from "astal/process";
import { Workspaces } from "./widgets/workspaces";
import { Clock } from "./widgets/clock";
import { Audio } from "./widgets/audio";
import { Backlight } from "./widgets/backlight";
import { Battery } from "./widgets/battery";
import { Weather } from "./widgets/weather";
import { GarbageCollector } from "./widgets/garbage";
import { SystemTray } from "./widgets/tray";
import { PowerMenu } from "./widgets/powermenu";

const Left = () => (
  <box>
    <button
      className="logo-btn"
      onClicked={async () => {
        await execAsync(["kitty", "-e", "geekymenu"]).catch(print);
      }}
    >
      <box className="logo-image" />
    </button>
    <Workspaces />
  </box>
);

const Center = () => (
  <box>
    <Clock />
    <Weather />
  </box>
);

const Right = () => (
  <box>
    <Audio />
    <Backlight />
    <Battery />
    <SystemTray />
    <PowerMenu />
  </box>
);

export default function Bar(monitor: number) {
  return (
    <window
      className="bar"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
      type={Gtk.WindowType.NORMAL}
    >
      <box heightRequest={52} className="bar-container">
        <Left />
        <box hexpand={true} />
        <Center />
        <box hexpand={true} />
        <Right />
      </box>
    </window>
  );
}
