local Log = require "log"
local Skynet = require "skynet"
local Service = require "service"

local Global = require "global"
local Client = require "client"

local Command = {}

function Command.client(source, fd, cmd, msg)
    Global.gate = source
    if Client[cmd] then
        local ret_msg = Client[cmd](source, msg)
        if ret_msg then
            Skynet.send(source, "lua", "send", Service.id, ret_msg)
        end
    else
        Log.error("client msg error!", cmd)
    end
end

function Command.kick()
    -- 保存角色数据
    Skynet.sleep(200)
end

function Command.exit()
    Skynet.exit()
end

return Command
