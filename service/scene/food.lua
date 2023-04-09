local Global = require "global"

local mrandom = math.random
local tinsert = table.insert
local pairs = pairs

local M = {}

M.food_maxid = 0
M.food_count = 0

function M.new()
    local m = {
        id = nil,
        x = mrandom(0, 100),
        y = mrandom(0, 100),
    }
    return m
end

-- 食物列表
function M.foodlist_msg()
    local msg = {"foodlist"}
    for _, food in pairs(Global.foods) do
        tinsert(msg, food.id)
        tinsert(msg, food.x)
        tinsert(msg, food.y)
    end
    return msg
end

return M