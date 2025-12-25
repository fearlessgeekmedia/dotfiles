import { interval, GLib } from "astal";

let generation = "?";

function getGeneration() {
  try {
    // Read the symlink target to get generation number
    const [ok, output] = GLib.spawn_command_line_sync("readlink /run/current-system");
    if (ok) {
      const target = new TextDecoder().decode(output).trim();
      const match = target.match(/generation-(\d+)-link/);
      if (match && match[1]) {
        generation = match[1];
        return;
      }
    }
  } catch (e) {
    print(`NixOS generation error: ${e}`);
  }
  // If anything fails, we'll know because of the '?'
  generation = "?";
}

// Initial call and update every 30 seconds
getGeneration();
interval(30000, getGeneration);

export function NixOS() {
  return (
    <box className="custom-nixos">
      <label label={`❄️ ${generation}`} />
    </box>
  );
}
