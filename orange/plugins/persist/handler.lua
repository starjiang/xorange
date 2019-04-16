local BasePlugin = require("orange.plugins.base_handler")
local persist = require("orange.plugins.persist.persist")
local orange_db = require("orange.store.orange_db")

local PersistHandler = BasePlugin:extend()
PersistHandler.PRIORITY = 1999

function PersistHandler:new(store)
    PersistHandler.super.new(self, "persist-plugin")
    self.store = store
end

function PersistHandler:init_worker()
    PersistHandler.super.init_worker(self)
    persist.init(self)
end

function PersistHandler:log()
    PersistHandler.super.log(self)

    local enable = orange_db.get("persist.enable")
    local meta = orange_db.get_json("persist.meta")
    
    if not enable or enable ~= true or not meta then
        return
    end

    ngx.log(ngx.INFO, "[Persist] check selectors")

    persist.log(self)
end

return PersistHandler
