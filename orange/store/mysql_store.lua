local type = type
local mysql_db = require("orange.store.mysql_db")
local Store = require("orange.store.base")

local MySQLStore = Store:extend()

function MySQLStore:new(options)
    local name = options.name or "mysql-store"
    self.super.new(self, name)
    self.store_type = "mysql"
    local connect_config = options.connect_config
    self.mysql_addr = connect_config.host .. ":" .. connect_config.port
    self.data = {}
    self.db = mysql_db(options)
end

function MySQLStore:query(opts)
    if not opts or opts == "" then return nil,"params is empty" end
    local param_type = type(opts)
    local res, err, sql, params
    if param_type == "string" then
        sql = opts
    elseif param_type == "table" then
        sql = opts.sql
        params = opts.params
    end

    return self.db:query(sql, params)
end

function MySQLStore:insert(opts)
    if not opts or opts == "" then return false end

    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        return self.db:insert(opts)
    elseif param_type == "table" then
        return self.db:insert(opts.sql, opts.params or {})
    end
    return nil,"invalid params type"
end

function MySQLStore:delete(opts)
    if not opts or opts == "" then return false end
    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        return self.db:delete(opts)
    elseif param_type == "table" then
        return self.db:delete(opts.sql, opts.params or {})
    end
    return nil,"invalid params type"
end

function MySQLStore:update(opts)
    if not opts or opts == "" then return false end
    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        return self.db:update(opts)
    elseif param_type == "table" then
        return self.db:update(opts.sql, opts.params or {})
    end
    return nil,"invalid params type"
end

return MySQLStore
