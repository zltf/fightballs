local Skynet = require "skynet"
local Service = require "service"
local Socket = require "skynet.socket"
local RunCfg = require "runconfig"
local Log = require "log"
local Pack = require "pack"

local Command = require "command"
local Global = require "global"

local tconcat = table.concat
local mrandom = math.random
local smatch = string.match

Service.cmd = Command

local function process_msg(fd, msgstr)
    local cmd, msg = Pack.str_unpack(msgstr)
    Log.info("recv " .. fd .. " [" .. cmd .. "] {" .. tconcat(msg, ",") .. "}")

    local conn = Global.conns[fd]
    local playerid = conn.playerid
    if not playerid then
        -- 未完成过登录
        local node = Skynet.getenv("node")
        local node_cfg = RunCfg[node]
        local loginid = mrandom(1, #node_cfg.login)
        local login = "login" .. loginid
        Skynet.send(login, "lua", "client", fd, cmd, msg)
    else
        -- 之前已经登录
        local gplayer = Global.players[playerid]
        local agent = gplayer.agent
        Skynet.send(agent, "lua", "client", cmd, msg)
    end
end

local function process_buff(fd, readbuff)
    while true do
        local msgstr, rest = smatch(readbuff, "(.-)\r\n(.*)")
        if msgstr then
            readbuff = rest
            process_msg(fd, msgstr)
        else
            return readbuff
        end
    end
end

local function disconnect(fd)
    local conn = Global.conns[fd]
    if not conn then
        return
    end
    Global.conns[fd] = nil

    local playerid = conn.playerid
    if not playerid then
        -- 未完成登录
        return
    end
    -- 已在游戏中
    Global.players[playerid] = nil

    Skynet.call("agentmgr", "lua", "reqkick", playerid, "断线")
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
    local conn = {
        fd = fd
    }
    Global.conns[fd] = conn
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
