import { interval, Variable } from "astal";
import { execAsync } from "astal/process";
import { Gtk } from "astal/gtk3";
import { bind } from "astal";

const weatherText = new Variable("🌤️");
const temperature = new Variable("");

const emojiMap: { [key: number]: string } = {
  113: "☀️", 116: "⛅", 119: "☁️", 122: "☁️",
  143: "🌧️", 176: "🌧️", 179: "🌨️", 182: "🌨️", 185: "🌨️",
  200: "⛈️", 227: "🌨️", 230: "🌨️", 248: "🌫️", 260: "🌫️",
  263: "🌧️", 266: "🌧️", 281: "🌧️", 284: "🌨️", 293: "🌧️",
  296: "🌧️", 299: "🌧️", 302: "🌧️", 305: "🌧️", 308: "🌧️",
  311: "🌧️", 314: "🌧️", 317: "🌧️", 320: "🌨️", 323: "🌨️",
  326: "🌨️", 329: "🌨️", 332: "🌨️", 335: "🌨️", 338: "🌨️",
  341: "🌨️", 344: "🌨️", 347: "🌧️", 350: "🌧️", 353: "🌧️",
  356: "🌧️", 359: "🌧️", 362: "🌧️", 365: "🌨️", 368: "🌨️",
  371: "🌨️", 374: "🌨️", 377: "🌨️", 386: "⛈️", 389: "⛈️",
  392: "⛈️", 395: "🌨️"
};

function fetchWeather() {
  execAsync(["curl", "-s", "https://wttr.in/?format=j1"])
    .then((output) => {
      const data = JSON.parse(output);
      const current = data.current_condition[0];
      const code = parseInt(current.weatherCode);
      weatherText.set(emojiMap[code] || "🌤️");
      temperature.set(`${current.temp_F}°F`);
    })
    .catch(() => {
      weatherText.set("🌤️");
      temperature.set("");
    });
}

fetchWeather();
interval(1800000, fetchWeather);

export function Weather() {
   return (
     <button className="custom-weather">
       <box spacing={4} halign={Gtk.Align.CENTER}>
         <label label={bind(weatherText)} />
         <label label={bind(temperature)} />
       </box>
     </button>
   );
 }
