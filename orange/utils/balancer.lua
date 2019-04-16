---
-- from https://github.com/Mashape/kong/blob/master/kong/core/balancer.lua
-- modified by zhjwpku@github

local orange_db = require "orange.store.orange_db"
local utils = require "orange.utils.utils"
local cjson = require "cjson"
local table_insert = table.insert

local balancers = {}  -- table holding our balancer objects, indexed by upstream name
local invalid_targets = {} --when target down,need invalidate target from upsteam pool
local invalid_expired_time = 60 --invalidate expired time

-- delect a balancer object from our internal cache
local function invalidate_balancer(upstream_name)
    balancers[upstream_name] = nil
end

-- finds and returns an upstream entity. This function covers
-- caching, invalidation, et al.
-- @return upstream table, or `false` if not found, or nil+error
local function get_upstream(upstream_name)
    -- selectors contains the upstreams
    local upstreams = orange_db.get_json("balancer.selectors")
    if not upstreams then
        return false  -- no upstreams cache
    end

    -- clear the balancers[upstream_name] that have been removed in orange_db
    local upstreams_dict = {}
    for _, upstream in pairs(upstreams) do
        if upstream and upstream.name then
            upstreams_dict[upstream.name] = upstream
        end
    end

    for k, _ in pairs(balancers) do
        if not upstreams_dict[k] then
            -- this one is not in orange_db, so clear the balancer object
            balancers[k] = nil
        end
    end

    local upstream_ret = upstreams_dict[upstream_name]
    if upstream_ret and upstream_ret.enable == true then
        return upstream_ret
    end

    return false -- no upstream by this name
end

local function invalidate_target(host,target)
    local targets = invalid_targets[host] or {}
    targets[target] = ngx.now()
    invalid_targets[host] = targets
end

local function check_invalid_target(host,target)
    local targets = invalid_targets[host]
    if not targets then
        return
    end
    return targets[target] ~= nil
end

local function restore_target(host)

    local targets = invalid_targets[host]
    if not targets then
        return
    end
    local now = ngx.now()
    for target, time in pairs(targets) do
        if now - time > invalid_expired_time then
            targets[target] = nil
        end
    end
end


local Balancer = {}


function Balancer:new(targets,method)
    local instance = {}
    instance._targets = targets
    instance._pos = 1
    instance._method = method
    setmetatable(instance, { __index = self })
    return instance
end


function Balancer:get_targets()
    return self._targets
end

function Balancer:get_method()
    return self._method
end

function Balancer:_get_index()

    if self._method == 'random_weight' then 
        local total = 0
        for i,v in ipairs(self._targets) do
            total = total+v.weight
        end

        local random = math.random(1,total)
        for i = 1,#self._targets do
          local weight = self._targets[i].weight or 0
          random = random - weight
          if random <= 0 then
            return i
          end
        end
        return 1
    elseif self._method == 'ip_hash' then
        local seq = ngx.crc32_short(ngx.var.remote_addr)
        local index = math.abs(seq) % #self._targets
        return index+1
    else --default round_robin
        if self._pos > #self._targets then
            self._pos = 1
        end

        local index = self._pos
        self._pos = self._pos+1
        return index
    end
end

function Balancer:get_peer()
    local target = self._targets[self:_get_index()]
    local ip = target.name
    local port = target.port
    local err

    if utils.hostname_type(target.name) == "name" then 
        ip,err = utils.toip(target.name,true)
        if not ip then
            return nil,nil,nil,err
        end
    end

    return ip,port,target.name,nil
end

-- looks up a balancer for the target.
-- @param target the table with the target details
-- @return balancer if found, or `false` if not found, or nil+error on error
local get_balancer = function(target)
    -- NOTE: only called upon first lookup, so `cache_only` limitations do not apply here
    local hostname = target.host

    -- first go and find the upstream object, from orange_db
    local upstream = get_upstream(hostname)

    if upstream == false then
        return nil,"no upstream for this name:"..hostname    -- no upstream by this name
    end

    -- we've got the upstream, now fetch its targets, from orange_db

    local targets = orange_db.get_json("balancer.selector." .. upstream.id .. ".rules")

    if not targets then
        return nil,"no targets for this name:"..hostname    -- TODO, for now, just simply reply false
    end

    restore_target(hostname)

    -- perform some raw data updates
    local enabled_targets = {}
    for i, t in ipairs(targets) do

        if t.enable  and not check_invalid_target(hostname,t.target) then
            -- split `target` field into `name` and `port`
            local port
            t.name, port = string.match(t.target, "^(.-):(%d+)$")
            t.port = tonumber(port)

            -- need exact order, so create sort-key by create-time and uuid
            t.order = t.time .. ":" .. t.id
            table_insert(enabled_targets, t)
        end
    end

    if #enabled_targets == 0 then
        return nil,"no enabled target for this name:"..hostname    -- no enabled host
    end

    table.sort(enabled_targets, function(a, b)
        return a.order < b.order
    end)

    local balancer = balancers[hostname]
    if not balancer then
        balancer = Balancer:new(enabled_targets,target.method)
        balancers[upstream.name] = balancer
    end

    local __size = #balancer:get_targets()
    local size = #enabled_targets

    if __size ~= size or balancer:get_targets()[__size].order ~= enabled_targets[size].order or balancer:get_method() ~= target.method then
        balancer = Balancer:new(enabled_targets,target.method)
        balancers[upstream.name] = balancer
    end

    return balancer,nil
end

local function execute(target)
    if target.type ~= "name" then
        target.ip = target.host
        target.port = target.port or 80
        target.hostname = target.host
        return true
    end

    local balancer,err = get_balancer(target)

    if balancer then
        target.balancer = balancer
        local ip, port, hostname,err = balancer:get_peer()
        ngx.log(ngx.INFO, "[Balancer] ",target.host," to ip:", ip, ",port:", port,",host:",hostname)
        if not ip then
            ngx.log(ngx.ERR, "can not get peer for '", tostring(target.host),"': ", port,",err:",err)
            return false
        end

        target.ip = ip
        target.port = port
        target.hostname = hostname

        return true

    else
        local ip, err = utils.toip(target.host,true)
        if not ip then
            ngx.log(ngx.ERR, "name resolution failed for '", tostring(target.host), "': ", target.port,",err:",err)
            return false
        end
    
        target.ip = ip
        target.hostname = target.host
        return true
    end
end

return {
    invalidate_target = invalidate_target,
    execute = execute,
    invalidate_balancer = invalidate_balancer,
}
