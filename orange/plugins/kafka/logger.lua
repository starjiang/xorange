local cjson = require "cjson"
local producer = require "resty.kafka.producer"

local _M = {}

local buffer = {}

function _M.log(data)
  table.insert(buffer,data)
end

function _M.flush( )

  if #buffer == 0 then
    return
  end

  local broker_list = context.config.plugin_config.kafka.broker_list
  local kafka_topic = context.config.plugin_config.kafka.topic
  local producer_config =  context.config.plugin_config.kafka.producer_config or {}
  producer_config.producer_type = 'async'
  
  local bp = producer:new(broker_list, producer_config)

  for i,v in ipairs(buffer) do
    local ok, err = bp:send(kafka_topic, nil, cjson.encode(v))
    if not ok then
        ngx.log(ngx.ERR,"kafka send err:", err)
    end
  end
  buffer = {}
end

return _M