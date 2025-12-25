import { Variable } from "astal";
import { execAsync } from "astal/process";

const WORKSPACE_ICONS = {
  "1": " ",
  "2": " ",
  "3": " ",
  "4": " ",
  "5": " ",
  "6": " ",
  "7": " ",
  "8": " ",
  "9": " ",
  "10": " ",
};

export function Workspaces() {
  const workspaces = Array.from({ length: 10 }, (_, i) => i + 1);

  const switchWorkspace = async (ws: number) => {
    // Use Niri msg action focus-workspace command
    try {
      const result = await execAsync(["niri", "msg", "action", "focus-workspace", ws.toString()]);
      print(`Switched to workspace ${ws}: ${result}`);
    } catch (error) {
      print(`Failed to switch to workspace ${ws}: ${error}`);
    }
  };

  return (
    <box className="workspaces" spacing={0}>
      {workspaces.map((ws) => (
        <button
          className="workspace"
          onClicked={() => {
            print(`Switching to workspace ${ws}`);
            switchWorkspace(ws);
          }}
        >
          <label label={`${ws}: ${WORKSPACE_ICONS[ws] || "●"}`} />
        </button>
      ))}
    </box>
  );
}
