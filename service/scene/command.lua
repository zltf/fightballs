local Skynet = require "skynet"
local Service = require "service"

local Global = require "global"
local Ball = require "ball"
local Food = require "food"

local Command = {}

local function broadcast(msg)
    for _, v in pairs(Global.balls) do
        Service.send(v.node, v.agent, "send", msg)
    end
end

-- 进入
function Command.enter(_, playerid, node, agent)
    if Global.balls[playerid] then
        Skynet.retpack(false)
        return
    end
    local b = Ball.new(playerid, node, agent)
    -- 广播
    local entermsg = {"enter", playerid, b.x, b.y, b.size}
    broadcast(entermsg)
    -- 记录
    Global.balls[playerid] = b
    -- 回应
    local ret_msg = {"enter", 0, "进入成功"}
    Service.send(b.node, b.agent, "send", ret_msg)
    -- 发送战场信息
    Service.send(b.node, b.agent, "send", Ball.balllist_msg())
    Service.send(b.node, b.agent, "send", Food.foodlist_msg())
    Skynet.retpack(true)
end

-- 退出
function Command.leave(_, playerid)
    if not Global.balls[playerid] then
        Skynet.retpack(false)
        return
    end
    Global.balls[playerid] = nil
    local leavemsg = {"leave", playerid}
    broadcast(leavemsg)
    Skynet.retpack(true)
end

function Command.shift(_, playerid, x, y)
    local b = Global.balls[playerid]
    if not b then
        Skynet.retpack(false)
        return
    end
    b.speedx = x
    b.speedy = y
    Skynet.retpack(true)
end

return Command
