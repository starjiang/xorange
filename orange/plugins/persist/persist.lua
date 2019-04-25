local socket = require("socket")
local orange_db = require("orange.store.orange_db")
local stringy = require("orange.utils.stringy")
local status = ngx.shared.status
local api_status = ngx.shared.api_status
local cjson = require("cjson")

local KEY_TOTAL_COUNT = "TOTAL_REQUEST_COUNT"
local KEY_TOTAL_SUCCESS_COUNT = "TOTAL_SUCCESS_REQUEST_COUNT"
local KEY_TRAFFIC_READ = "TRAFFIC_READ"
local KEY_TRAFFIC_WRITE = "TRAFFIC_WRITE"
local KEY_TOTAL_REQUEST_TIME = "TOTAL_REQUEST_TIME"

local KEY_REQUEST_2XX = "REQUEST_2XX"
local KEY_REQUEST_3XX = "REQUEST_3XX"
local KEY_REQUEST_4XX = "REQUEST_4XX"
local KEY_REQUEST_5XX = "REQUEST_5XX"

function toint(x)
    local y = math.ceil(x)
    if y == x then
        return x
    else
        return y - 1
    end
end

local _M = {}

local flush_interval = 60

local function start_flush_timer(premature,callback)
    
    local ok,err = pcall(callback)

    if err then 
        ngx.log(ngx.ERR,"flush data fail:",err)
    end

    local ok, err = ngx.timer.at(flush_interval,start_flush_timer,callback)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
    end
end

local function concat(input)
    local output = "("
    local len = #input
    for index, value in ipairs(input) do
        output = output.."'"..value.."'"
        if index < len then  
            output=output..","
        end
    end
    output=output..")"
    return output
end

local function write_data(config)

    local enable = orange_db.get("persist.enable")
    
    if not enable or enable ~= true then
        return
    end

    local apis = api_status:get_keys()

    ngx.log(ngx.INFO,"flush api monitor data to db ",cjson.encode(apis))

    local result, err
    local table_name = 'api_persist_log'
    local sql = "INSERT " .. table_name .. " " ..
    " (ip,domain,api,stat_time,request_2xx, request_3xx, request_4xx, request_5xx, total_request_count, total_success_request_count, avg_traffic_read, avg_traffic_write, avg_request_time) " ..
    " VALUES "

    local len = #apis
    for index, key in ipairs(apis) do  

        -- 暂存
        local request_2xx = status:get(KEY_REQUEST_2XX..key)
        local request_3xx = status:get(KEY_REQUEST_3XX..key)
        local request_4xx = status:get(KEY_REQUEST_4XX..key)
        local request_5xx = status:get(KEY_REQUEST_5XX..key)
        local total_count = status:get(KEY_TOTAL_COUNT..key)
        local total_success_count = status:get(KEY_TOTAL_SUCCESS_COUNT..key)
        local traffic_read = status:get(KEY_TRAFFIC_READ..key)
        local traffic_write = status:get(KEY_TRAFFIC_WRITE..key)
        local total_request_time = status:get(KEY_TOTAL_REQUEST_TIME..key)
        -- 清空计数
        status:set(KEY_REQUEST_2XX..key, 0)
        status:set(KEY_REQUEST_3XX..key, 0)
        status:set(KEY_REQUEST_4XX..key, 0)
        status:set(KEY_REQUEST_5XX..key, 0)
        status:set(KEY_TOTAL_COUNT..key, 0)
        status:set(KEY_TOTAL_SUCCESS_COUNT..key, 0)
        status:set(KEY_TRAFFIC_READ..key, 0)
        status:set(KEY_TRAFFIC_WRITE..key, 0)
        status:set(KEY_TOTAL_REQUEST_TIME..key, 0)

        local meta = stringy.split(key,":")

        local domain = meta[2]
        local api_path = meta[3]
        -- 存储统计
        local node_ip = _M.get_ip()
        local now = ngx.now()
        local date_now = os.date('*t', now)
        local min = date_now.min
        local stat_time = string.format('%d-%d-%d %d:%d:00',date_now.year, date_now.month, date_now.day, date_now.hour, min)
        local avg_request_time = 0
        if total_count >0 and total_request_time > 0 then
            avg_request_time = total_request_time/total_count
        end

        local avg_traffic_read = 0
        if total_count >0 and traffic_read > 0 then
            avg_traffic_read = traffic_read/total_count
        end

        local avg_traffic_write = 0
        if total_count >0 and traffic_write > 0 then
            avg_traffic_write = traffic_write/total_count
        end

        local params = {
            node_ip,
            domain,
            api_path,
            stat_time,
            tonumber(request_2xx) or 0,
            tonumber(request_3xx) or 0,
            tonumber(request_4xx) or 0,
            tonumber(request_5xx) or 0,
            tonumber(total_count) or 0,
            tonumber(total_success_count) or 0,
            tonumber(avg_traffic_read) or 0,
            tonumber(avg_traffic_write) or 0,
            tonumber(avg_request_time) or 0
        }   
        
        sql = sql..concat(params)

        if index < len then
            sql = sql..","
        end
    end

    if len > 0 then
        result = config.store:insert(sql)
        if not result then
            ngx.log(ngx.ERR, "insert data into mysql has error")
        end
    end
    api_status:flush_all()

end

-- 获取 IP
local function get_ip_by_hostname(hostname)
    local _, resolved = socket.dns.toip(hostname)
    local list_tab = {}
    for _, v in ipairs(resolved.ip) do
        table.insert(list_tab, v)
    end
    return unpack(list_tab)
end

function _M.init(config)
    ngx.log(ngx.ERR, "persist init worker")

    if ngx.worker.id() == 0 then
            -- 定时保存
        start_flush_timer(nil,function()
            write_data(config)
        end)
        
    end
end

function _M.log(config)
    local ngx_var = ngx.var
    local prefix = ":"..ngx_var.host..":"..ngx_var.uri

    api_status:add(prefix,"")

    status:incr(KEY_TOTAL_COUNT..prefix, 1,0)

    local http_status = tonumber(ngx_var.status)

    if http_status < 400 then
        status:incr(KEY_TOTAL_SUCCESS_COUNT..prefix, 1,0)
    end

    if http_status >= 200 and http_status < 300 then
        status:incr(KEY_REQUEST_2XX..prefix, 1,0)
    elseif http_status >= 300 and http_status < 400 then
        status:incr(KEY_REQUEST_3XX..prefix, 1,0)
    elseif http_status >= 400 and http_status < 500 then
        status:incr(KEY_REQUEST_4XX..prefix, 1,0)
    elseif http_status >= 500 and http_status < 600 then
        status:incr(KEY_REQUEST_5XX..prefix, 1,0)
    end


    status:incr(KEY_TRAFFIC_READ..prefix, ngx_var.request_length,0)
    status:incr(KEY_TRAFFIC_WRITE..prefix, ngx_var.bytes_sent,0)
    local request_time = ngx.now()*1000 - ngx.req.start_time()*1000
    status:incr(KEY_TOTAL_REQUEST_TIME..prefix, request_time,0)
end

function _M.get_ip()
    if not _M.ip then
        _M.ip = get_ip_by_hostname(socket.dns.gethostname())
    end
    return _M.ip
end

return _M
