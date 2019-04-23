local lor = require("lor.index")

return function(config, store)

    local persist_router = lor:Router()
    local persist_model = require("dashboard.model.persist")(config)

    persist_router:get("/persist", function(req, res, next)
        res:render("persist-api-stat", {
            id = req.query.id,
            ip = req.query.ip
        })
    end)

    persist_router:get("/persist/api_stats", function(req, res, next)
        local ip = req.query.ip or ''
        local period = tonumber(req.query.period) or 5
        local data
        if ip == '' then
            data = persist_model:get_api_stats(period)
        else
            data = persist_model:get_api_stats_by_ip(period,ip)
        end
        res:json({
            total = #data,
            rows = data
        })
    end)

    persist_router:get("/persist/api_stats_data", function(req, res, next)
        local ip = req.query.ip or ''
        local period = tonumber(req.query.period) or 1440
        local api = req.query.api or '/'
        local domain = req.query.domain or 'localhost'
        local data,err 
        if ip == '' then
            data,err  = persist_model:get_api_stats_data(period,api,domain)
        else
            data,err  = persist_model:get_api_stats_data(period,api,domain,ip)
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


    return persist_router
end
