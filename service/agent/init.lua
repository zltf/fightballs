local skynet = require "skynet"
local Service = require "service"

local Command = require "command"
local Global = require "global"

Service.cmd = Command

function Service.init()
    -- 加载角色数据
    Skynet.sleep(200)
    Global.data = {
        coin = 100,
        hp = 200,
    }
end

Service.start(...)
