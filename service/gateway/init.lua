local Skynet = require "skynet"
local Service = require "service"
local Socket = require "skynet.socket"
local RunCfg = require "runconfig"
local Log = require "log"

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
    Socket.start(fd)
    Log.info("socket connected " .. fd)
    local readbuff = ""
    while true do
        local recvstr = Socket.read(fd)
        if recvstr then
            readbuff = readbuff .. recvstr
            readbuff = process_buff(fd, readbuff)
        else
            Log.info("socket close " .. fd)
            disconnect(fd)
            Socket.close(fd)
            return
        end
    end
end

local function connect(fd, addr)
    Log.info("connect from " .. addr .. " " .. fd)
    local c = conn()
    conns[fd] = c
    c.fd = fd
    Skynet.fork(recv_loop, fd)
end

function Service.init()
    local node = Skynet.getenv("node")
    local node_cfg = RunCfg[node]
    local port = node_cfg.gateway[Service.id].port

    local listenfd = Socket.listen("0.0.0.0", port)
    Log.info("Listen socket :", "0.0.0.0", port)
    Socket.start(listenfd, connect)
end

Service.start(...)
