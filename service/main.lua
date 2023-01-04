local Skynet = require "skynet"
local Log = require "log"
local RunCfg = require "runconfig"

Skynet.start(function()
    -- 初始化
    Log.info("[start main]")
    local node = Skynet.getenv("node")
    local node_cfg = RunCfg[node]

    for i = 1, #node_cfg.gateway do
        Skynet.newservice("gateway", "gateway", i)
    end

    for i = 1, #node_cfg.login do
        Skynet.newservice("login", "login", i)
    end

    if node == RunCfg.agentmgr.node then
        Skynet.newservice("agentmgr", "agentmgr", 1)
    end

    Skynet.newservice("nodemgr", "nodemgr", 1)

    -- 退出自身
    Skynet.exit()
end)
