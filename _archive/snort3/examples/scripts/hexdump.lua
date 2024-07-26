lua_path = os.getenv('LUA_PATH')
if ( not lua_path ) then
    package.path = '/home/snorty/snort3/include/snort/lua/?.lua;?;'
end

-- this pulls in snort bindings with ffi
require("snort_plugin")

function hexdump(buf)
    for byte=1, #buf, 16 do
        local chunk = buf:sub(byte, byte+15)
        io.write(string.format('%08X  ',byte-1))
        chunk:gsub('.', function(c)
            io.write(string.format('%02X ',string.byte(c)))
        end)
        io.write(string.rep(' ',3*(16-#chunk)+1))
        chunk:gsub('.', function(c)
            local c = string.byte(c)
            if c > 0x1f and c < 0x7f then
                io.write(string.format("%c", c))
            else
                io.write('.')
            end 
        end) 
        io.write("\n")
    end
    print()
end

-- init() is optional
-- if present, called once when script is loaded
-- here we return bool indicating args ok
-- function init ()
--     return true
-- end

-- eval() is required
-- eval must return a bool (match == true)
function eval ()
    -- buf is a luajit cdata
    local buf = ffi.C.get_buffer()

    -- str is a lua string
    local str = ffi.string(buf.data, buf.len)

    local t = ffi.string(buf.type)
    io.write(string.format("[%s]\n", t))
    hexdump(str)

    return true
end

-- plugin table is required
plugin =
{
    type = "ips_option",  -- only available type currently
    name = "hexdump",     -- rule option keyword
    version = 0           -- optional, defaults to zero
}
