import { interval, GLib } from "astal";
import { execAsync } from "astal/process";

let volumeText = "-- %";

function getVolumeSync() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("wpctl get-volume @DEFAULT_AUDIO_SINK@");
    if (ok) {
      const match = output.toString().match(/Volume: ([\d.]+)/);
      if (match) {
        const vol = Math.round(parseFloat(match[1]) * 100);
        return `${vol}% 󰕾`;
      }
    }
  } catch (e) {
    print(`Volume error: ${e}`);
  }
  return "-- %";
}

volumeText = getVolumeSync();

interval(1000, () => {
  execAsync(["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"])
    .then((output) => {
      const match = output.match(/Volume: ([\d.]+)/);
      if (match) {
        const vol = Math.round(parseFloat(match[1]) * 100);
        volumeText = `${vol}% 󰕾`;
      }
    })
    .catch(() => {});
});

export function Audio() {
  return (
    <button className="pulseaudio">
      <label label={volumeText} />
    </button>
  );
}
