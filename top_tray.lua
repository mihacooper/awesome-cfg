local textclock = awful.widget.textclock({ align = "right" })
local systray   = widget({ type = "systray" })

if context.promptbox == nil then context.promptbox = {} end
if context.layoutbox == nil then context.layoutbox = {} end
if context.taglist   == nil then context.taglist   = {} end
if context.tasklist  == nil then context.tasklist  = {} end
context.taglist.buttons = awful.util.table.join(
    awful.button({},1,awful.tag.viewonly),
    awful.button({modkey},1,awful.client.movetotag)
    )

context.textclock = textclock
context.systray = systray

local function loader(screen)
    context.promptbox[screen] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    context.layoutbox[screen] = awful.widget.layoutbox(screen)
    context.taglist[screen]   = awful.widget.taglist(screen, awful.widget.taglist.label.all)
    context.tasklist[screen]  = awful.widget.tasklist(
        function(c)
            return awful.widget.tasklist.label.currenttags(c, screen)
        end)
    return 
    {
        {
            context.taglist[screen],
            context.promptbox[screen],
            layout = awful.widget.layout.horizontal.leftright
        },
        context.layoutbox[screen],
        context.textclock,
        screen == 1 and context.systray or nil,
        context.tasklist[screen],
        layout = awful.widget.layout.horizontal.rightleft
    }
end

return loader
