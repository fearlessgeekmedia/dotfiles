import { interval, GLib, Variable, bind } from "astal";
import { execAsync } from "astal/process";

const brightness = new Variable("-- %");

function getBrightnessSync() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("cat /sys/class/backlight/intel_backlight/brightness");
    if (ok) {
      const max = new TextDecoder().decode(GLib.spawn_command_line_sync("cat /sys/class/backlight/intel_backlight/max_brightness")[1]);
      const percent = Math.round((parseInt(new TextDecoder().decode(output)) / parseInt(max)) * 100);
      return `${percent}% 󰳲`;
    }
  } catch (e) {
    print(`Brightness error: ${e}`);
  }
  return "-- %";
}

brightness.set(getBrightnessSync());

interval(1000, () => {
  execAsync(["bash", "-c", "cat /sys/class/backlight/intel_backlight/brightness"])
    .then((output) => {
      execAsync(["bash", "-c", "cat /sys/class/backlight/intel_backlight/max_brightness"])
        .then((max) => {
          const percent = Math.round((parseInt(output) / parseInt(max)) * 100);
          brightness.set(`${percent}% 󰳲`);
        })
        .catch(() => {});
    })
    .catch(() => {});
});

export function Backlight() {
  return (
    <button className="backlight">
      <label label={bind(brightness)} />
    </button>
  );
}
