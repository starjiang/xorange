local BaseAPI = require("orange.plugins.base_api")
local common_api = require("orange.plugins.common_api")

local api = BaseAPI:new("api-stat-api", 2)
api:merge_apis(common_api("api_stat"))

return api
