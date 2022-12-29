local Skynet = require "skynet"

local M = {}

function M.info(...)
    Skynet.error("[INF]", ...)
end

function M.debug(...)
    Skynet.error("[DEG]", ...)
end

function M.warning(...)
    Skynet.error("[WAR]", ...)
end

function M.error(...)
    Skynet.error("[ERR]", ...)
end

return M