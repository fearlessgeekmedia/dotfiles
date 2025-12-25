import { App, Gtk, Gdk } from "astal/gtk3";
import Bar from "./bar";

// Enable dark mode preference before App.start
const settings = Gtk.Settings.get_default();
if (settings) {
  settings.set("gtk-application-prefer-dark-theme", true);
}

App.start({
  css: "/home/fearlessgeek/.config/ags/style.css",
  main() {
    const bar = Bar(0);
    bar.show_all();
  },
});
