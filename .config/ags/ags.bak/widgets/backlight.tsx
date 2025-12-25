import { interval, GLib } from "astal";
import { execAsync } from "astal/process";

let brightnessText = "-- %";

function getBrightnessSync() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("cat /sys/class/backlight/intel_backlight/brightness");
    if (ok) {
      const max = GLib.spawn_command_line_sync("cat /sys/class/backlight/intel_backlight/max_brightness")[1].toString();
      const percent = Math.round((parseInt(output.toString()) / parseInt(max)) * 100);
      return `${percent}% 󰳲`;
    }
  } catch (e) {
    print(`Brightness error: ${e}`);
  }
  return "-- %";
}

brightnessText = getBrightnessSync();

interval(1000, () => {
  execAsync(["bash", "-c", "cat /sys/class/backlight/intel_backlight/brightness"])
    .then((output) => {
      execAsync(["bash", "-c", "cat /sys/class/backlight/intel_backlight/max_brightness"])
        .then((max) => {
          const percent = Math.round((parseInt(output) / parseInt(max)) * 100);
          brightnessText = `${percent}% 󰳲`;
        })
        .catch(() => {});
    })
    .catch(() => {});
});

export function Backlight() {
  return (
    <button className="backlight">
      <label label={brightnessText} />
    </button>
  );
}
