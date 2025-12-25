import { interval, Variable } from "astal";
import { execAsync } from "astal/process";
import { bind } from "astal";

const timeText = new Variable("");

function getTimeString() {
  const now = new Date();
  return now.toLocaleString("en-US", {
    weekday: "short",
    month: "short",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: undefined,
    hour12: true,
  });
}

function updateTime() {
  timeText.set(getTimeString());
  print(`Time updated: ${timeText.get()}`);
}

// Initialize immediately
updateTime();

// Update every second
interval(1000, updateTime);

export function Clock() {
  return (
    <button
      className="clock"
      onClicked={async () => {
        await execAsync(["kitty", "-e", "geekcalendar"]).catch(print);
      }}
      widthRequest={200}
    >
      <label label={bind(timeText)} />
    </button>
  );
}
