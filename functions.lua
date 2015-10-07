modkey = 'Mod4'

function frun(prg)
    os.execute(prg .. " &")
end

function fdo(prg)
    os.execute(prg)
end

function fexec(cmd)
   local f = io.popen(cmd, 'r')
   local buffer = f.read(f,'*a')
   return buffer, buffer ~= ''
end

function ferror(etitle, emsg)
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = etitle,
                     text = emsg })
end

function getenv(var)
    local out, _ = fexec("echo $" .. var)
    return out
end
