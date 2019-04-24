local BaseAPI = require("orange.plugins.base_api")
local common_api = require("orange.plugins.common_api")
local table_insert = table.insert
local api = BaseAPI:new("waf-api", 2)
api:merge_apis(common_api("waf"))

return api
