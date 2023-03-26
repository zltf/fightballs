local Skynet = require "skynet"
require "skynet.manager"
local Log = require "log"
local RunCfg = require "runconfig"
local Cluster = require "skynet.cluster"

Skynet.start(function()
    -- 初始化
    Log.info("[start main]")
    local node = Skynet.getenv("node")
    local node_cfg = RunCfg[node]

    -- 节点管理
    local nodemgr = Skynet.newservice("nodemgr", "nodemgr", 0)
    Skynet.name("nodemgr", nodemgr)

    -- 集群
    Cluster.reload(RunCfg.cluster)
    Cluster.open(node)

    -- gate
    for i = 1, #node_cfg.gateway do
        local srv = Skynet.newservice("gateway", "gateway", i)
        Skynet.name("gateway" .. i, srv)
    end

    -- login
    for i = 1, #node_cfg.login do
        local srv = Skynet.newservice("login", "login", i)
        Skynet.name("login" .. i, srv)
    end

    -- agentmgr
    if node == RunCfg.agentmgr.node then
        local srv = Skynet.newservice("agentmgr", "agentmgr", 1)
        Skynet.name("agentmgr", srv)
    else
        local proxy = Cluster.proxy(RunCfg.agentmgr.node, "agentmgr")
        Skynet.name("agentmgr", proxy)
    end

    -- 退出自身
    Skynet.exit()
end)
