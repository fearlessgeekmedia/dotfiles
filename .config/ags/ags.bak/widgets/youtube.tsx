import { interval } from "astal";
import { execAsync } from "astal/process";

let ytCount = "0";

interval(15000, () => {
  execAsync(["bash", "-c", "$HOME/.local/scripts/ytsubs.sh"])
    .then((output) => {
      ytCount = output.trim();
    })
    .catch(() => {});
});

export function YouTubeSubs() {
  return (
    <button className="custom-ytube">
      <label label={`󰗃 ${ytCount}`} />
    </button>
  );
}
