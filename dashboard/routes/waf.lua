local lor = require("lor.index")

return function(config, store)

    local waf_router = lor:Router()
    local waf_model = require("dashboard.model.waf")(config)

    waf_router:get("/waf/ip_list", function(req, res, next)
      local ip = req.query.ip or ''
      local period = tonumber(req.query.period) or 5
      local data
      if ip == '' then
          data = waf_model:get_api_stats(period)
      else
          data = waf_model:get_api_stats_by_ip(period,ip)
      end
      res:json({
          total = #data,
          rows = data
      })
    end)
    return waf_router
end
