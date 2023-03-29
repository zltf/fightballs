local M = {}

local mrandom = math.random

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

return M