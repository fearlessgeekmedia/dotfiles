import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import { Variable } from "astal";
import { Workspaces } from "./widgets/workspaces";
import { Clock } from "./widgets/clock";
import { Audio } from "./widgets/audio";
import { Backlight } from "./widgets/backlight";
import { Battery } from "./widgets/battery";
import { Updates } from "./widgets/updates";
import { Weather } from "./widgets/weather";
import { YouTubeSubs } from "./widgets/youtube";
import { SystemTray } from "./widgets/tray";
import { PowerMenu } from "./widgets/powermenu";

export default function Bar(monitor: number) {
  return (
    <window
      className="bar"
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={App}
      type={Gtk.WindowType.NORMAL}
    >
      <box spacing={0} margin={[0, 0, 0, 0]} hexpand vexpand>
         {/* Left */}
         <box spacing={0} hexpand={false}>
           <Workspaces />
           <Updates />
         </box>

         {/* Center */}
         <box hexpand halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER} spacing={0}>
           <Clock />
           <Weather />
         </box>

         {/* Right */}
         <box halign={Gtk.Align.END} hexpand={false} spacing={0}>
          <Audio />
          <Backlight />
          <Battery />
          <YouTubeSubs />
          <SystemTray />
          <PowerMenu />
        </box>
      </box>
    </window>
  );
}
