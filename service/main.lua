local Skynet = require "skynet"
local Log = require "log"

Skynet.start(function()
    -- 初始化
    Log.info("[start main]")
    Skynet.newservice("gateway", "gateway", 1)
    -- 退出自身
    Skynet.exit()
end)
