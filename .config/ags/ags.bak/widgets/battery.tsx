import { interval, GLib, Variable } from "astal";
import { execAsync } from "astal/process";
import { Gtk } from "astal/gtk3";
import { bind } from "astal";

const currentBattery = new Variable("...");

function getBatterySync() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("cat /sys/class/power_supply/BAT0/capacity");
    if (ok) {
      const text = output.toString().trim();
      return `${parseInt(text)}%`;
    }
  } catch (e) {
    print(`Error: ${e}`);
  }
  return "ERR";
}

currentBattery.set(getBatterySync());

// Update async
interval(5000, () => {
  execAsync(["cat", "/sys/class/power_supply/BAT0/capacity"])
    .then((output) => {
      currentBattery.set(`${parseInt(output.trim())}%`);
      print(`Updated: ${currentBattery.get()}`);
    })
    .catch((e) => {
      print(`Err: ${e}`);
    });
});

export function Battery() {
  return (
    <button className="battery">
      <box spacing={4} halign={Gtk.Align.CENTER}>
        <label label="🔋" />
        <label label={bind(currentBattery)} />
      </box>
    </button>
  );
}
