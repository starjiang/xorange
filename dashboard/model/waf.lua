local DB = require("dashboard.model.db")

return function(config)

    local node_model = {}
    local mysql_config = config.store_mysql
    local db = DB:new(mysql_config)

    function node_model:get_ip_list(rule_id)        
        local sql="SELECT * from ip_list where rule_id=?"
        return db:query(sql, {rule_id})
    end

    function node_model:add_ip(rule_id,ip)
      local sql="insert into ip_list (rule_id,ip) values(?,?)"
      return db:insert(sql, {rule_id,ip})
    end

    function node_model:delete_ip(rule_id,ip)
      local sql="delete from ip_list rule_id=? and ip=?"
      return db:delete(sql, {rule_id,ip})
    end

    return node_model
end

