local Skynet = require "skynet"
require "skynet.manager"
local Cluster = require "skynet.cluster"
local Log = require "log"

local M = {
    -- 类型和id
    name = "",
    id = 0,
    -- 回调函数
    init = nil,
    exit = nil,
    -- 分发方法
    cmd = {},
}

local function traceback(err)
    Log.error(tostring(err))
    Log.error(debug.traceback())
end

local function dispatch(session, address, cmd, ...)
    local fun = assert(M.cmd[cmd], cmd)
    local ok, err = pcall(fun, address, ...)
    if not ok then
        traceback(err)
    end
end

local function init()
    Skynet.dispatch("lua", dispatch)
    Skynet.register(string.format("%s%d", M.name, M.id))
    if M.init then
        M.init()
    end
end

function M.start(name, id, ...)
    M.name = name
    M.id = tonumber(id)
    Skynet.start(init)
end

function M.call(node, srv, ...)
    local mynode = Skynet.getenv("node")
    if node == mynode then
        return Skynet.call(srv, "lua", ...)
    else
        return Cluster.call(node, srv, ...)
    end
end

function M.send(node, srv, ...)
    local mynode = Skynet.getenv("node")
    if node == mynode then
        return Skynet.send(srv, "lua", ...)
    else
        return Cluster.send(node, srv, ...)
    end
end

return M
