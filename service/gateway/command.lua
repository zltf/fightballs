local Log = require "log"
local Socket = require "skynet.socket"
local Skynet = require "skynet"
local Pack = require "pack"

local Global = require "global"

local tconcat = table.concat

local Command = {}

function Command.send_by_fd(_, fd, msg)
    if not Global.conns[fd] then
        return
    end

    local buff = Pack.str_pack(msg[1], msg)
    Log.info("send " .. fd .. " [" .. msg[1] .. "] {" .. tconcat(msg, ",") .. "}")
    Socket.write(fd, buff)
end

function Command.send(_, playerid, msg)
    local gplayer = Global.players[playerid]
    if not gplayer then
        return
    end
    local conn = gplayer.conn
    if not conn then
        return
    end

    Command.send_by_fd(nil, conn.fd, msg)
end

function Command.sure_agent(_, fd, playerid, agent)
    local conn = Global.conns[fd]
    if not conn then
        -- 登录过程中已经下线
        Skynet.call("agentmgr", "lua", "reqkick", playerid, "未完成登录即下线")
        Skynet.retpack(false)
        return
    end

    conn.playerid = playerid

    local gplayer = {
        playerid = playerid,
        agent = agent,
        conn = conn
    }
    Global.players[playerid] = gplayer

    Skynet.retpack(true)
end

function Command.kick(_, playerid)
    local gplayer = Global.players[playerid]
    if not gplayer then
        Skynet.ret()
        return
    end
    Global.players[playerid] = nil

    local conn = gplayer.conn
    if not conn then
        Skynet.ret()
        return
    end
    Global.conns[conn.fd] = nil

    Socket.close(conn.fd)

    Skynet.ret()
end

return Command
