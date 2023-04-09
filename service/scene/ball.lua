local Global = require "global"

local tinsert = table.insert
local pairs = pairs

local M = {}

local mrandom = math.random

function M.new(playerid, node, agent)
    local m = {
        playerid = playerid,
        node = node,
        agent = agent,
        x = mrandom(0, 100),
        y = mrandom(0, 100),
        size = 2,
        speedx = 0,
        speedy = 0,
    }
    return m
end

-- 球列表
function M.balllist_msg()
    local msg = {"balllist"}
    for _, ball in pairs(Global.balls) do
        tinsert(msg, ball.playerid)
        tinsert(msg, ball.x)
        tinsert(msg, ball.y)
        tinsert(msg, ball.size)
    end
    return msg
end

return M