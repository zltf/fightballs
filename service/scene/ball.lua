local M = {}

local mrandom = math.random

function M.new()
    local m = {
        playerid = nil,
        node = nil,
        agent = nil,
        x = mrandom(0, 100),
        y = mrandom(0, 100),
        size = 2,
        speedx = 0,
        speedy = 0,
    }
    return m
end

return M