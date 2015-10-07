require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("debian.menu")
require("vicious")

require("functions")

ENV_SCRIPT_PATH = ".config/awesome/scripts/"
ROOT_PATH = ".config/awesome/"
TAGS_FILE = "tags"
context = {}

if awesome.startup_errors then
    ferror("Oops, there were errors during startup!", awesome.startup_errors)
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        ferror("Oops, an error happened!", err)
        in_error = false
    end)
end

-- Variable definitions
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
terminal   = "xfce4-terminal"
browser    = "chromium-browser"
gui_editor = "subl"
editor     = "nano"--os.getenv("vim") or "vim"
editor_cmd = terminal .. " -e " .. editor


layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier
}
context.layouts = layouts

bottom_tray_loader = require("bottom_tray")
top_tray_loader = require("top_tray")
context.tags = {}
for s = 1, screen.count() do
    context.tags[s] = {}
    for line in io.lines(ROOT_PATH .. "tags") do
      local t = awful.tag.add(line, {screen = s, layout = layouts[1]})
      table.insert(context.tags[s], t)
    end

    topwibox = awful.wibox({ position = "top", screen = s })
    topwibox.widgets = top_tray_loader(s)

    bottomwibox = awful.wibox({ position = "bottom", screen = s })
    bottomwibox.widgets = bottom_tray_loader(s)
end

-- Key and buttons binding
-- Global for enviroment
-- client for applications
hotkeys_loader = require("hotkeys")
local globalkeys, globalbuttons = hotkeys_loader()
root.buttons(globalbuttons)
root.keys(globalkeys)


-- Load signals
signals_loader = require("signals")
signals_loader()

-- Load rules and run applications
apprules_loader = require("apprules")
apprules_loader()
