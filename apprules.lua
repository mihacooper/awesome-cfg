require("functions")

local clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

local clientbuttons = awful.util.table.join(
    --awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

local function set_rules()
    local rules = {
        { rule = { },
          properties = { border_width = beautiful.border_width,
                         border_color = beautiful.border_normal,
                         focus = true,
                         keys = clientkeys,
                         buttons = clientbuttons } },
        { rule = { class = "Firefox" },
          properties = {tag = context.tags[1][2]}},
        { rule = { class = "Chromium-browser" },
          properties = { tag = context.tags[1][2]} },
        { rule = { class = "telegram" },
          properties = { tag = context.tags[1][4]} },
        { rule = { class = "xfce4-terminal" },
          properties = { tag = context.tags[1][1] } },
        { rule = { class = "subl" },
          properties = { tag = context.tags[1][3] } },
        { rule = { class = "Thunar" },
          properties = { tag = context.tags[1][5] } },
        { rule = { class = "QtCreator" },
          properties = { tag = context.tags[1][3] } },
        -- Чтоб узнать имя класса окна, вбей: xprop | grep -i class
    }
    return rules
end

local function already_run(prg)
    local _, ret = fexec("pidof " .. prg)
    return ret
end

function run_once(prg, fullname)
    if not already_run(fullname or prg) then
        frun(prg)
    end
end

local function runner()
    awful.rules.rules = set_rules()
    run_once("nm-applet")
    run_once("chromium-browser")
    run_once("xfce4-terminal")
    run_once("thunar")
    run_once("telegram")
end

return runner