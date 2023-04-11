local Skynet = require "skynet"
local Service = require "service"
local Log = require "log"

local Command = require "command"
local Global = require "global"
local Food = require "food"

local pairs = pairs
local mrandom = math.random
local pcall = pcall

Service.cmd = Command

local function food_update()
    if Food.food_count > 50 then
        return
    end
    if mrandom(1, 100) > 98 then
        return
    end
    local f = Food.new()
    Global.foods[f.id] = f
    local msg = {"addfood", f.id, f.x, f.y}
    Global.broadcast(msg)
end

local function move_update()
    for _, ball in pairs(Global.balls) do
        ball.x = ball.x + ball.speedx * 0.2
        ball.y = ball.y + ball.speedy * 0.2
        if ball.speedx ~= 0 or ball.speedy~= 0 then
            local msg = {"move", ball.playerid, ball.x, ball.y}
            Global.broadcast(msg)
        end
    end
end

local function eat_update()
    for pid, ball in pairs(Global.balls) do
        for fid, food in pairs(Global.foods) do
            if (ball.x - food.x) ^ 2 + (ball.y - food.y) ^ 2 < ball.size ^ 2 then
                ball.size = ball.size + 1
                Food.food_count = Food.food_count - 1
                local msg = {"eat", pid, fid, ball.size}
                Global.broadcast(msg)
                Global.foods[fid] = nil
            end
        end
    end
end

local function update(_)
    food_update()
    move_update()
    eat_update()
    -- 碰撞
    -- 分裂
end

function Service.init()
    Skynet.fork(function()
        -- 保持帧率执行
        local stime = Skynet.now()
        local frame = 0
        while true do
            frame = frame + 1
            local ok, err = pcall(update, frame)
            if not ok then
                Log.error(err)
            end
            local etime = Skynet.now()
            local waittime = frame * 20 - (etime - stime)
            if waittime <= 0 then
                waittime = 2
            end
            Skynet.sleep(waittime)
        end
    end)
end

Service.start(...)
