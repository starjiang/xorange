local lor = require("lor.index")

return function(config, store)

    local api_stat_router = lor:Router()
    local model = require("dashboard.model.api_stat")(config)

    api_stat_router:get("/api_stat", function(req, res, next)
        res:render("api_stat", {
            id = req.query.id,
            ip = req.query.ip
        })
    end)

    api_stat_router:get("/api_stat/list", function(req, res, next)
        local ip = req.query.ip or ''
        local period = tonumber(req.query.period) or 5
        local data
        if ip == '' then
            data = model:get_api_stats(period)
        else
            data = model:get_api_stats_by_ip(period,ip)
        end
        res:json({
            total = #data,
            rows = data
        })
    end)

    api_stat_router:get("/api_stat/data", function(req, res, next)
        local ip = req.query.ip or ''
        local period = tonumber(req.query.period) or 1440
        local api = req.query.api or '/'
        local domain = req.query.domain or 'localhost'
        local data,err 
        if ip == '' then
            data,err  = model:get_api_stats_data(period,api,domain)
        else
            data,err  = model:get_api_stats_data(period,api,domain,ip)
        end
        if err then 
            res:json({
                ret=1,
                msg = err,
                data = data
            })
        else
            res:json({
                ret=0,
                msg='ok',
                data = data
            })
        end
    end)


    return api_stat_router
end
