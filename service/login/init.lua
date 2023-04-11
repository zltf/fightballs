local Skynet = require "skynet"
local Service = require "service"
local Log = require "log"

local tonumber = tonumber

local client = {}

function client.login(source, fd, msg)
    local playerid = tonumber(msg[2])
    local pwd = tonumber(msg[3])
    local gate = source
    local node = Skynet.getenv("node")
    -- 校验密码
    if pwd ~= 123 then
        return {"login", 1, "密码错误"}
    end
    -- 发给agentmgr
    local ok, agent = Skynet.call("agentmgr", "lua", "reqlogin", playerid, node, gate)
    if not ok then
        return {"login", 1, "请求mgr失败"}
    end
    -- 回应gate
    ok = Skynet.call(gate, "lua", "sure_agent", fd, playerid, agent)
    if not ok then
        return {"login", 1, "gate注册失败"}
    end
    Log.info("login succ" .. playerid)
    return {"login", 0, "登录成功"}
end

function Service.cmd.client(source, fd, cmd, msg)
    if client[cmd] then
        local ret_msg = client[cmd](source, fd, msg)
        Skynet.send(source, "lua", "send_by_fd", fd, ret_msg)
    else
        Log.error("client msg error!", cmd)
    end
end

Service.start(...)
