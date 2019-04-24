local lor = require("lor.index")
local stringy = require("orange.utils.stringy")
return function(config, store)

    local waf_router = lor:Router()
    local waf_model = require("dashboard.model.waf")(config)

    waf_router:get("/waf/ip_list", function(req, res, next)
      local rule_id = req.query.rule_id
      local data,err = waf_model:get_ip_list(rule_id)
      if err then
        ngx.log(ngx.ERR,"get ip list fail:",err)
        res:json({
          total = 0,
          rows = {}
        })
      else
        res:json({
            total = #data,
            rows = data
        })
      end
    end)
    
    waf_router:get("/waf/add_ip", function(req, res, next)
      local rule_id = req.query.rule_id
      local ip = stringy.trim_all(req.query.ip)
      local result,err = waf_model:add_ip(rule_id,ip)
      if err then
        res:json({
          ret = 1,
          msg = err
        })
      else
        res:json({
          ret = 0,
          msg = 'ok'
        })
      end
    end)

    waf_router:get("/waf/delete_ip", function(req, res, next)
      local rule_id = req.query.rule_id
      local ip_list = req.query.ip

      local result,err = waf_model:delete_ip(rule_id,ip_list)
      if err then
        res:json({
          ret = 1,
          msg = err
        })
      else
        res:json({
          ret = 0,
          msg = 'ok'
        })
      end
    end)
    return waf_router
end
