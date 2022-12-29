local Skynet = require "skynet"
local Cluster = require "skynet.cluster"
local Log = require "log"

local M = {
    -- 类型和id
    name = "",
    id = 0,
    -- 回调函数
    exit = nil,
    init = nil,
    -- 分发方法
    resp = {},
}

local function traceback(err)
    Log.error(tostring(err))
    Log.error(debug.traceback())
end

local function dispatch(session, address, cmd, ...)
    local fun = M.resp[cmd]
    if not fun then
        Skynet.ret()
        return
    end

    local ret = table.pack(xpcall(fun, traceback, address, ...))
    local isok = ret[1]

    if not isok then
        Skynet.ret()
        return
    end

    Skynet.retpack(table.unpack(ret, 2))
end

local function init()
    Skynet.dispatch("lua", dispatch)
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
