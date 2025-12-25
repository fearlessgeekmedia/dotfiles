import { interval, GLib } from "astal";
import { execAsync } from "astal/process";

let updateCount = "0";

function getUpdatesSync() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("bash -c 'xbps-install -SuMn 2>/dev/null | awk \"{print \\$1}\" | wc -l'");
    if (ok) {
      return output.toString().trim();
    }
  } catch (e) {
    print(`Updates error: ${e}`);
  }
  return "0";
}

updateCount = getUpdatesSync();

interval(7200000, () => {
  execAsync(["bash", "-c", "xbps-install -SuMn 2>/dev/null | awk '{print $1}' | wc -l"])
    .then((output) => {
      updateCount = output.toString().trim();
      print(`Updates: ${updateCount}`);
    })
    .catch((e) => print(`Updates err: ${e}`));
});

export function Updates() {
  return (
    <button className="custom-updates">
      <label label={`🔄 ${updateCount}`} />
    </button>
  );
}
