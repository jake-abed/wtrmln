// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/wtrmln_web.ex",
    "../lib/wtrmln_web/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
        "melon-red": "#EB5657",
        "melon-green": "#22A554",
        "melon-black": "#505050",
      },
      boxShadow: {
        "message": "4px 4px 16px 4px rgba(0, 0, 0, 0.6)",
        "heavy-inner": "inset 2px 2px 4px 2px rgba(0, 0, 0, 0.6)",
        "red-clay": "inset 2px 2px 8px 3px #FE9F8F, inset -3px -3px 8px 3px #CA3141, 1px 1px 10px 1px #A9113166",
        "green-clay": "inset 2px 2px 8px 3px #55CC89, inset -3px -3px 8px 3px #117329, 1px 1px 10px 1px #11532066",
        "white-clay": "inset -3px -3px 8px 3px #00000066, 1px 1px 10px 2px #00000033"
      },
      fontFamily: {
        "noto": ["Noto Sans", "sans-serif"]
      },
      keyframes: {
        grow: {
          "0%": { "transform": "scaleY(0.85) scaleX(0.95)", "opacity": "0" },
          "100%": { "transform": "scaleY(1) scaleX(1)", "opacity": "1" }
        }
      },
      animation: {
        messageGrow: "grow 0.7s ease-in-out 1 normal forwards"
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": theme("spacing.5"),
            "height": theme("spacing.5")
          }
        }
      }, {values})
    })
  ]
}
