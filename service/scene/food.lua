local Global = require "global"

local mrandom = math.random
local tinsert = table.insert
local pairs = pairs

local M = {}

M.food_maxid = 0
M.food_count = 0

function M.new()
    M.food_count = M.food_count + 1
    M.food_maxid = M.food_maxid + 1
    local m = {
        id = M.food_maxid,
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