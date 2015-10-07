
local function separator()
    local w = widget({type = "textbox"})
    w.text = "  ::  "
    return w
end

local function memory()
    local wid = widget({type = "textbox"})
    vicious.register(wid, vicious.widgets.mem, "RAM: $2Mb", 13)
    return wid
end

local function cputherm()
    local wid = widget({type = "textbox"})
    vicious.register(wid, vicious.widgets.thermal,
        "CPU: $1 °C", 20, "thermal_zone0")
    return wid
end

local function cpuusage()
    local wid = widget({type = "textbox"})
    vicious.register(wid, vicious.widgets.cpu,
        function(widget, args)
            if string.len(args[1])==1 then
                args[1]=" " .. args[1]
            end
            if string.len(args[2])==1 then
                args[2]=" " .. args[2]
            end
            return "CPU: " .. args[1] .. "%|" .. args[2] .. "%"
       end)
    return wid
end

local function cpupolicy()
    local wid = widget({type = "textbox"})
    vicious.register(wid, vicious.widgets.cpuinf, 
        function(widget,args)
          local info = " "--"CPU mode: "
          local fd1=io.popen("sudo cpufreq-info | grep 'The governor \"powersave\"'", "r")
          local line1=fd1:read()

          local fd2=io.popen("sudo cpufreq-info | grep 'The governor \"performance\"'", "r")
          local line2=fd2:read()

          if line1 then
            return info .. "<span color=\"#77CC77\">powersave</span>"
          elseif line2 then
            return info .. "<span color=\"#CC7777\">performance</span>"
          else
            --set_cpu_powersave()
            return info .. "unknown"
          end
        end
      , 2)
    return wid
end


local function battery()
    local wid = widget({ type = "textbox"})
    function battery_status ()
        local output={} --output buffer
        local fd=io.popen("acpitool -b", "r") --list present batteries
        local line=fd:read()
        while line do --there might be several batteries.
            local battery_num = string.match(line, "Battery \#(%d+)")
            local battery_load = string.match(line, " (%d*\.%d+)%%")
            local time_rem = string.match(line, "(%d+\:%d+)\:%d+")
            local discharging

            if string.match(line, "discharging")=="discharging" then --discharging: always red
                discharging="<span color=\"#CC7777\">"
            elseif tonumber(battery_load)>70 then --almost charged
                discharging="<span color=\"#77CC77\">"
            elseif tonumber(battery_load)>30 then
                discharging="<span color=\"#CCCC77\">"
            else --charging
                discharging="<span color=\"#CC4444\">"
            end

            if battery_num and battery_load and time_rem then
                table.insert(output,discharging.."BAT: "
                    --..battery_num.." "
                    ..battery_load.."% ("..time_rem.."h)</span>"
                    )
            elseif battery_num and battery_load then --remaining time unavailable
                table.insert(output,discharging.."BAT:"
                    --..battery_num.." "
                    ..battery_load.."%</span>")
            end --even more data unavailable: we might be getting an unexpected output format, so let's just skip this line.
            line=fd:read() --read next line
        end
        return table.concat(output," ") --FIXME: better separation for several batteries. maybe a pipe?
    end
    local timer = timer({ timeout = 120 })
    timer:add_signal("timeout",
        function()
            wid.text = " " .. battery_status() .. " "
        end)
    timer:start()
    vicious.register(wid, vicious.widgets.bat, battery_status, 30, "BAT1")
    return wid
end


local function volume()
    function get_volume()
        local value = io.popen(ENV_SCRIPT_PATH .. "getvolumevalue.sh"):read()
        local state = io.popen(ENV_SCRIPT_PATH .. "getvolumestate.sh"):read()
        local info = " ♫ " .. value .. "%"
        if state then
            info = info .. "<span color=\"#CC7777\"> M </span>"
        end
        return info
    end

    local wid = widget({ type = "textbox" })
    vicious.register(wid, vicious.widgets.volume, get_volume, 0.1, "PCM")
    return wid
end

local function loadwidgets(screen)
    return
    {
        {
            memory(),
            separator(),
            cputherm(),
            separator(),
            cpuusage(),
            cpupolicy(),
            separator(),
            battery(),
            separator(),
            volume(),
            layout = awful.widget.layout.horizontal.leftright
         },
        layout = awful.widget.layout.horizontal.rightleft
    }
end

return loadwidgets
