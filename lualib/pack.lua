local M = {}

function M.str_pack(_, msg)
    return table.concat(msg, ",") .. "\r\n"
end

function M.str_unpack(msgstr)
    local msg = {}
    for arg in string.gmatch(msgstr, "[^,]*") do
        table.insert(msg, arg)
    end
    return msg[1], msg
end

return M
