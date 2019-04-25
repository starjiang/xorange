local BasePlugin = require("orange.plugins.base_handler")
local rules_cache = require("orange.utils.rules_cache")
local logger = require("orange.plugins.kafka.logger")
local util = require("orange.utils.utils")
local producer = require "resty.kafka.producer"

local  KafkaHandler = BasePlugin:extend()
KafkaHandler.PRIORITY = 2000
local log_flush_interval = 5

function KafkaHandler:new(store)
    KafkaHandler.super.new(self, "kafka-plugin")
    self.store = store
end

local function start_flush_log()
    local ok,err = pcall(logger.flush)
    if err then
        ngx.log(ngx.ERR,"logger.flush fail:",err)
    end
    ngx.timer.at(log_flush_interval,start_flush_log)
end

function KafkaHandler:init_worker()
    KafkaHandler.super.init_worker(self)
    start_flush_log()
end

function KafkaHandler:log()

    KafkaHandler.super.log(self)
   
    local enable = rules_cache.get_enable("kafka")
   
    if not enable or enable ~= true then
        return
    end

    local log_json = {}
    log_json["remote_addr"] = ngx.var.remote_addr or '-'
    log_json["time"] = util.now()
    log_json['method'] = ngx.var.request_method or '-'
    log_json["status"] = ngx.var.status or '-'
    log_json["body_bytes_sent"] = ngx.var.body_bytes_sent or '-'
    log_json["http_referer"] = ngx.var.http_referer or '-'
    log_json["http_user_agent"] = ngx.var.http_user_agent or '-'
    log_json["request_time"] = ngx.var.request_time or '-'
    log_json["uri"] = ngx.var.uri or '-'
    log_json["args"] = ngx.var.args or '-'
    log_json["host"]= ngx.var.host or '-'
    log_json['upstream_addr'] = ngx.var.upstream_addr or ' -'
    log_json["server_addr"] = ngx.var.server_addr or '-'

    logger.log(log_json)

end


return KafkaHandler
