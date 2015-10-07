require("functions")

local function loader()
    local globalkeys = awful.util.table.join(
        awful.key({ }, "XF86AudioRaiseVolume", function ()
            fdo("amixer -c 1 set Master 5%+")
           end),
        awful.key({ }, "XF86AudioLowerVolume", function ()
            fdo("amixer -c 1 set Master 5%-")
            end),
        awful.key({ }, "XF86AudioMute", function ()
            fdo(ENV_SCRIPT_PATH .. "changevolumestate.sh")
            end),
        awful.key({ modkey, }, "t",
            function ()
                awful.prompt.run(
                  { prompt = "Tag name: " },
                  context.promptbox[mouse.screen].widget,
                  function (name)
                        fdo(ENV_SCRIPT_PATH .. "tagadd.sh " .. ROOT_PATH .. TAGS_FILE .. " " .. name)
                        awesome.restart()
                    end)
            end),
        awful.key({ modkey, "Shift"}, "t",
            function ()
                awful.prompt.run(
                  { prompt = "Tag name: " },
                  context.promptbox[mouse.screen].widget,
                  function (name)
                        fdo(ENV_SCRIPT_PATH .. "tagdel.sh " .. ROOT_PATH .. TAGS_FILE .. " " .. name)
                        awesome.restart()
                    end)
            end),
        awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),

        --awful.key({ modkey,            }, "p", function ()
        --    switch_cpu_mode()
        --    end),

       --awful.key({ modkey,            }, "w", function ()
       --     reboot_wifi()
       --     end),

        awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
        awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
        awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

        awful.key({ modkey,           }, "]",
            function ()
                awful.client.focus.byidx( 1)
                if client.focus then client.focus:raise() end
            end),
        awful.key({ modkey,           }, "[",
            function ()
                awful.client.focus.byidx(-1)
                if client.focus then client.focus:raise() end
            end),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
        awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
        awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
        awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),

        -- Standard program
        awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
        awful.key({ modkey, "Control" }, "r", awesome.restart),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit),

        awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
        awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
        awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
        awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
        awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
        awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
        awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
        awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

        awful.key({ modkey, "Control" }, "n", awful.client.restore),

        -- Prompt
        awful.key({ modkey },            "r", function () context.promptbox[mouse.screen]:run() end),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run({ prompt = "Run Lua code: " },
                      context.promptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
                  end)
    )

    local globalbuttons = awful.util.table.join(
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
    )

    local tags = context.tags
    local keynumber = 0
    for s = 1, screen.count() do
       keynumber = math.min(9, math.max(#tags[s], keynumber));
    end

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, keynumber do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = mouse.screen
                            if tags[screen][i] then
                                awful.tag.viewonly(tags[screen][i])
                            end
                      end),
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          if tags[screen][i] then
                              awful.tag.viewtoggle(tags[screen][i])
                          end
                      end),
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and tags[client.focus.screen][i] then
                              awful.client.movetotag(tags[client.focus.screen][i])
                          end
                      end),
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus and tags[client.focus.screen][i] then
                              awful.client.toggletag(tags[client.focus.screen][i])
                          end
                      end))
    end

    return globalkeys, globalbuttons
end

return loader
