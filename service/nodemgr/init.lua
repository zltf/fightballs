local Skynet = require "skynet"
local Service = require "service"

local Command = {}

function Command.newservice(source, name, ...)
    local srv = Skynet.newservice(name, ...)
    Skynet.retpack(srv)
end

Service.cmd = Command

Service.start(...)
