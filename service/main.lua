local Skynet = require "skynet"
local Log = require "log"
local RunCfg = require "runconfig"

Skynet.start(function()
    -- 初始化
    Log.info("[start main]")
    local node = Skynet.getenv("node")
    local node_cfg = RunCfg[node]

    Skynet.newservice("gateway", "gateway", 1)

    for i = 1, #node_cfg.login do
        Skynet.newservice("login", "login", i)
    end

    -- 退出自身
    Skynet.exit()
end)
