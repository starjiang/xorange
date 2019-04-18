---
-- from https://github.com/Mashape/kong/blob/master/kong/plugins/base_plugin.lua
-- modified by sumory.wu

local Object = require("orange.lib.classic")
local BasePlugin = Object:extend()

function BasePlugin:new(name)
    self._name = name
end

function BasePlugin:get_name()
    return self._name
end

function BasePlugin:init_worker()
end

function BasePlugin:redirect()
end

function BasePlugin:rewrite()
end

function BasePlugin:access()
end

function BasePlugin:balancer()
end

function BasePlugin:log()
end

return BasePlugin
