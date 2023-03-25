local Global = require "global"

local Client = {}

function Client.work(source, msg)
    Global.data.coin = Global.data.coin + 1
    return {
        "work",
        Global.data.coin,
    }
end

return Client