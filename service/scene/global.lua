local Service = require "service"

local pairs = pairs

local Global = {}

Global.balls = {} -- playerid -> balls
Global.foods = {} -- id -> food

function Global.broadcast(msg)
    for _, v in pairs(Global.balls) do
        Service.send(v.node, v.agent, "send", msg)
    end
end

return Global
