local DB = require("dashboard.model.db")
local stringy = require("orange.utils.stringy")
local ip_list_cache = ngx.shared.waf_ip_list

return function(config)

    local model = {}
    local mysql_config = config.store_mysql
    local db = DB:new(mysql_config)

    function model:get_ip_list(rule_id)        
        local sql="SELECT * from ip_list where rule_id=? order by create_time desc"
        return db:query(sql, {rule_id})
    end

    function model:add_ip(rule_id,ip)
      ip_list_cache:set("waf."..rule_id.."."..ip,ip)
      local sql="insert into ip_list (rule_id,ip) values(?,?)"
      return db:insert(sql, {rule_id,ip})
    end

    function model:get_delete_list(ip_list_str)
      local ip_list = stringy.split(ip_list_str,",")
      return ip_list;
    end

    function model:get_placeholder(count)
      local placeholder = ''
      for i=1,count do
        placeholder = placeholder.."?"
        if i < count then
          placeholder = placeholder..","
        end
      end
      return placeholder
    end

    function model:delete_ip(rule_id,ip_list)
      local list = self:get_delete_list(ip_list)
      
      for i,v in ipairs(list) do
        ip_list_cache:delete("waf."..rule_id.."."..v)
      end

      local sql="delete from ip_list where rule_id=? and ip in ("..self:get_placeholder(#list)..")"
      table.insert( list, 1, rule_id )
      return db:delete(sql, list)
    end

    return model
end

