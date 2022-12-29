local skynet = require "skynet"
local s = require "service"
local socket = require "skynet.socket"
local runconfig = require "runconfig"

local conns = {} -- fd -> conn，连接和玩家的关联
local players = {} -- playerid -> gateplayer，玩家和agent的关联

-- 连接类
function conn()
    local m = {
        fd = nil,
        playerid = nil,
    }
    return m
end

-- 玩家类
function gateplayer()
    local m = {
        playerid = nil,
        agent = nil,
        conn = nil,
    }
    return m
end

local function process_buff(fd, readbuff)
end

local function disconnect(fd)
end

-- 每一条连接接收数据处理
-- 协议格式：cmd,arg1,arg2,...#
local function recv_loop(fd)
    socket.start(fd)
    skynet.error("socket connected " .. fd)
    local readbuff = ""
    while true do
        local recvstr = socket.read(fd)
        if recvstr then
            readbuff = readbuff .. recvstr
            readbuff = process_buff(fd, readbuff)
        else
            skynet.error("socket close " .. fd)
            disconnect(fd)
            socket.close(fd)
            return
        end
    end
end

local function connect(fd, addr)
    skynet.error("connect from " .. addr .. " " .. fd)
    local c = conn()
    conns[fd] = c
    c.fd = fd
    skynet.fork(recv_loop, fd)
end

function s.init()
    local node = skynet.getenv("node")
    local nodecfg = runconfig[node]
    local port = nodecfg.gateway[s.id].port

    local listenfd = socket.listen("0.0.0.0", port)
    skynet.error("Listen socket :", "0.0.0.0", port)
    socket.start(listenfd, connect)
end

s.start(...)
