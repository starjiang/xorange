local BasePlugin = require("orange.plugins.base_handler")
local persist = require("orange.plugins.api_stat.persist")
local rules_cache = require("orange.utils.rules_cache")

local ApiStatHandler = BasePlugin:extend()
ApiStatHandler.PRIORITY = 1999

function ApiStatHandler:new(store)
    ApiStatHandler.super.new(self, "api-stat-plugin")
    self.store = store
end

function ApiStatHandler:init_worker()
    ApiStatHandler.super.init_worker(self)
    persist.init(self)
end

function ApiStatHandler:log()
    ApiStatHandler.super.log(self)

    local enable = rules_cache.get_enable("api_stat")
    if not enable or enable ~= true then
        return
    end
    ngx.log(ngx.INFO, "[ApiStat] report data")

    persist.log(self)
end

return ApiStatHandler
