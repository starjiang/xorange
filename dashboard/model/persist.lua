local DB = require("dashboard.model.db")

return function(config)

    local node_model = {}
    local mysql_config = config.store_mysql
    local db = DB:new(mysql_config)

    function node_model:get_api_stats_data(period,api,domain)
        local now = ngx.now()
        now = now-period*60

        local date_now = os.date('*t', now)
        local min = date_now.min
        local start_time = string.format('%d-%d-%d %d:%d:00',date_now.year, date_now.month, date_now.day, date_now.hour, min)
        
        local sql="SELECT stat_time,domain,api,SUM(request_2xx) AS 2xx,SUM(request_3xx) AS 3xx,SUM(request_4xx) AS 4xx,SUM(request_5xx) AS 5xx,SUM(total_request_count) AS total,AVG(avg_traffic_read) AS avg_read,AVG(avg_traffic_write) AS avg_write,AVG(avg_request_time) AS avg_time FROM api_persist_log WHERE stat_time >= ? AND api=? AND domain=? GROUP BY stat_time,api,domain"
        return db:query(sql, {start_time,api,domain})
    end

    function node_model:get_stats_data_by_ip(period,api,domain,ip)
        local now = ngx.now()
        now = now-period*60

        local date_now = os.date('*t', now)
        local min = date_now.min
        local start_time = string.format('%d-%d-%d %d:%d:00',date_now.year, date_now.month, date_now.day, date_now.hour, min)
        
        local sql="SELECT stat_time,domain,api,SUM(request_2xx) AS 2xx,SUM(request_3xx) AS 3xx,SUM(request_4xx) AS 4xx,SUM(request_5xx) AS 5xx,SUM(total_request_count) AS total,AVG(avg_traffic_read) AS avg_read,AVG(avg_traffic_write) AS avg_write,AVG(avg_request_time) AS avg_time FROM api_persist_log WHERE stat_time >= ? AND api=? AND domain=? and ip=?d GROUP BY stat_time,api,domain"
        return db:query(sql, {start_time,api,domain,ip})

    end

    function node_model:get_api_stats(period)
        local now = ngx.now()
        now = now-period*60

        local date_now = os.date('*t', now)
        local min = date_now.min
        local start_time = string.format('%d-%d-%d %d:%d:00',date_now.year, date_now.month, date_now.day, date_now.hour, min)
        
        local sql="SELECT domain,api,SUM(request_2xx) AS 2xx,SUM(request_3xx) AS 3xx,SUM(request_4xx) AS 4xx,SUM(request_5xx) AS 5xx,SUM(total_request_count) AS total,AVG(avg_traffic_read) AS avg_read,AVG(avg_traffic_write) AS avg_write,AVG(avg_request_time) AS avg_time FROM api_persist_log WHERE stat_time>= ? GROUP BY api,domain order by total desc"
        return db:query(sql, {start_time})

    end

    function node_model:get_api_stats_by_ip(period,ip)

        local now = ngx.now()
        now = now-period*60

        local date_now = os.date('*t', now)
        local min = date_now.min
        local start_time = string.format('%d-%d-%d %d:%d:00',date_now.year, date_now.month, date_now.day, date_now.hour, min)
        
        local sql="SELECT domain,api,SUM(request_2xx) AS 2xx,SUM(request_3xx) AS 3xx,SUM(request_4xx) AS 4xx,SUM(request_5xx) AS 5xx,SUM(total_request_count) AS total,AVG(avg_traffic_read) AS avg_read,AVG(avg_traffic_write) AS avg_write,AVG(avg_request_time) AS avg_time FROM api_persist_log WHERE stat_time>= ? and ip = ? GROUP BY api,domain order by total desc"
        return db:query(sql, {start_time,ip})

    end


    return node_model
end

