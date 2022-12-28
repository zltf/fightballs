local skynet = require "skynet"
local s = require "service"

function s.init()
    skynet.error("[start]" .. s.name .. " " .. s.id)
end

s.start(...)
