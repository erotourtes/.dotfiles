local hypr_dir = debug.getinfo(1, "S").source:match("^@(.*/)")

if hypr_dir == nil then
    hypr_dir = os.getenv("HOME") .. "/.config/hypr/"
end

local config_dir = hypr_dir .. "config/"
local helpers = require("./config/helpers")

---@type HyprColors
local colors = helpers.load_colors(config_dir)

---@type HyprConfigContext
local ctx = {
    terminal = "kitty",
    file_manager = "nautilus",
    menu = "rofi -show drun",

    keys = {
        mod = "SUPER",
    },

    colors = colors,

    monitors = {
        primary = "eDP-1",
        secondary = "HDMI-A-1",
    },

    dirs = {
        hypr = hypr_dir,
        config = config_dir,
        scripts = hypr_dir .. "scripts",
    },

    plugins = {
        hy3 = hl.plugin.hy3,
    },

    tags = {
        no_screen_share = "no_screen_share",
    },
}

require("./config/startup").run(ctx)
require("./config/monitors").run(ctx)
require("./config/input").run(ctx)

require("./config/appearance").run(ctx)
require("./config/rules").run(ctx)
require("./config/perms").run(ctx)

require("./config/binds").run(ctx)
require("./config/default_layout").run(ctx)
require("./config/hy3").run(ctx)
require("./config/ext/ext1").run(ctx)
