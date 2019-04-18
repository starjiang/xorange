local orange_db = require("orange.store.orange_db")
local _M = {}

local expired_time =  5

function _M.get_meta(plugin)
  local key = plugin..".meta"
  local info = _M[key]
  if info and info.expired_time +expired_time > ngx.now() then
    return info.data
  else
    local data = orange_db.get_json(key)
    _M[key]={data=data,expired_time=ngx.now()}
    return data
  end
end

function _M.get_selectors(plugin)
  local key = plugin..".selectors"
  local info = _M[key]
  if info and info.expired_time +expired_time > ngx.now() then
    return info.data
  else
    local data = orange_db.get_json(key)
    _M[key]={data=data,expired_time=ngx.now()}
    return data
  end
end

function _M.get_rules(plugin,sid)

  local key = plugin .. ".selector." .. sid .. ".rules"
  local info = _M[key]
  if info and info.expired_time +expired_time > ngx.now() then
    return info.data
  else
    local data = orange_db.get_json(key)
    _M[key]={data=data,expired_time=ngx.now()}
    return data
  end
end

return _M