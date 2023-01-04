local Log = require "log"
local Skynet = require "skynet"
local Service = require "service"

local Global = require "global"

local Command = {}

function Command.reqlogin(source, playerid, node, gate)
    local mplayer = Global.players[playerid]
    -- 登录登出过程中禁止顶替
    if mplayer and mplayer.status == Global.STATUS.LOGOUT then
        Log.error("reqlogin fail, at status LOGOUT " .. playerid)
        Skynet.retpack(false)
        return
    end
    if mplayer and mplayer.status == Global.STATUS.LOGIN then
        Log.error("reqlogin fail, at status LOGIN " .. playerid)
        Skynet.retpack(false)
        return
    end
    -- 在线，顶替
    if mplayer then
        local pnode = mplayer.node
        local pagent = mplayer.agent
        local pgate = mplayer.gate
        mplayer.status = Global.STATUS.LOGOUT
        Service.call(pnode, pagent, "kick")
        Service.send(pnode, pagent, "exit")
        Service.send(pnode, pgate, "send", playerid, {"kick", "顶替下线"})
        Service.call(pnode, pgate, "kick", playerid)
    end
    -- 上线
    local player = {
        playerid = playerid,
        node = node,
        gate = gate,
        agent = nil,
        status = Global.STATUS.LOGIN,
    }
    Global.players[playerid] = player
    local agent = Service.call(node, "nodemgr", "newservice", "agent", "agent", playerid)
    player.agent = agent
    player.status = Global.STATUS.GAME

    Skynet.retpack(true, agent)
end

function Command.reqkick(source, playerid, reason)
    local mplayer = Global.players[playerid]
    if not mplayer then
        Skynet.retpack(false)
        return
    end

    if mplayer.status ~= Global.STATUS.GAME then
        Skynet.retpack(false)
        return
    end

    local pnode = mplayer.node
    local pagent = mplayer.agent
    local pgate = mplayer.gate
    mplayer.status = Global.STATUS.LOGOUT

    Service.call(pnode, pagent, "kick")
    Service.send(pnode, pagent, "exit")
    Service.call(pnode, pgate, "kick", playerid)

    Global.players[playerid] = nil

    Skynet.retpack(true)
end

return Command