local tconcat = table.concat
local tinsert = table.insert
local sgmatch = string.gmatch

local M = {}

function M.str_pack(_, msg)
    return tconcat(msg, ",") .. "\r\n"
end

function M.str_unpack(msgstr)
    local msg = {}
    for arg in sgmatch(msgstr, "[^,]*") do
        tinsert(msg, arg)
    end
    return msg[1], msg
end

return M
