import { interval, GLib } from "astal";

// --- CPU Widget ---

let cpuUsage = "0%";
let prevIdle = 0;
let prevTotal = 0;

function calculateCpuUsage() {
  try {
    const [ok, output] = GLib.spawn_command_line_sync("head -n1 /proc/stat");
    if (!ok) {
        cpuUsage = "0%";
        return;
    }

    const cpuData = new TextDecoder().decode(output).trim().split(/\s+/).slice(1).map(Number);
    const [user, nice, system, idle, iowait, irq, softirq, steal] = cpuData;

    const currentIdle = idle + iowait;
    const currentTotal = user + nice + system + currentIdle + irq + softirq + steal;

    const totalDiff = currentTotal - prevTotal;
    const idleDiff = currentIdle - prevIdle;

    prevIdle = currentIdle;
    prevTotal = currentTotal;
    
    if (totalDiff === 0) return; // Keep previous value if no change
    
    const usage = Math.round((100 * (totalDiff - idleDiff)) / totalDiff);
    cpuUsage = `${usage}%`;

  } catch (e) {
    print(`CPU usage error: ${e}`);
    cpuUsage = "Error"; // Indicate an error state
  }
}

interval(2000, calculateCpuUsage);

export function CPU() {
  return (
    <box className="custom-cpu">
      <label label={`💻 ${cpuUsage}`} />
    </box>
  );
}

// --- Network Widget (Static for now) ---

export function Network() {
    return (
        <box className="custom-network">
            <label label="🔻 Network" />
        </box>
    );
}