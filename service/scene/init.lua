local Global = require "global"

local tinsert = table.insert
local pairs = pairs

-- 球列表
local function balllist_msg()
    local msg = {"balllist"}
    for _, ball in pairs(Global.balls) do
        tinsert(msg, ball.playerid)
        tinsert(msg, ball.x)
        tinsert(msg, ball.y)
        tinsert(msg, ball.size)
    end
    return msg
end

-- 食物列表
local function foodlist_msg()
    local msg = {"foodlist"}
    for _, food in pairs(Global.foods) do
        tinsert(msg, food.id)
        tinsert(msg, food.x)
        tinsert(msg, food.y)
    end
    return msg
end
