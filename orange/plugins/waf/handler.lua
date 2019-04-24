local pairs = pairs
local ipairs = ipairs
local judge_util = require("orange.utils.judge")
local extractor_util = require("orange.utils.extractor")
local handle_util = require("orange.utils.handle")
local BasePlugin = require("orange.plugins.base_handler")
local rules_cache = require("orange.utils.rules_cache")
local ip_list_cache = ngx.shared.waf_ip_list

local function filter_rules(sid, plugin, ngx_var_uri)
    local rules = rules_cache.get_rules(plugin,sid)
    if not rules or type(rules) ~= "table" or #rules <= 0 then
        return false
    end

    for i, rule in ipairs(rules) do
        if rule.enable == true then
            -- judge阶段
            local pass = judge_util.judge_rule(rule, plugin)
            -- handle阶段
            if pass then
                local handle = rule.handle
                local ip = ip_list_cache:get("waf."..rule.id.."."..ngx.var.remote_addr)
                local perform = handle.perform

                if ip then
                    ngx.log(ngx.INFO,"[",ip,"] in [",rule.name,"] extra ip list")
                    if perform == 'allow' then
                        perform = 'deny'
                    else
                        perform = 'allow'
                    end
                end

                if perform == 'allow' then
                    if handle.log == true then
                        ngx.log(ngx.INFO, "[WAF-Pass-Rule] ", rule.name, " uri:", ngx_var_uri)
                    end
                else
                    if handle.log == true then
                        ngx.log(ngx.INFO, "[WAF-Forbidden-Rule] ", rule.name, " uri:", ngx_var_uri)
                    end
                    ngx.exit(tonumber(handle.code or 403))
                    return true
                end
            end
        end
    end

    return false
end


local WAFHandler = BasePlugin:extend()
WAFHandler.PRIORITY = 2000

function WAFHandler:new(store)
    WAFHandler.super.new(self, "waf-plugin")
    self.store = store
end

function WAFHandler:access(conf)
    WAFHandler.super.access(self)

    local enable = rules_cache.get_enable("waf")
    if not enable or enable ~= true then
        return
    end

    local meta = rules_cache.get_meta("waf")
    local selectors = rules_cache.get_selectors("waf")
    local ordered_selectors = meta and meta.selectors

    if not meta or not ordered_selectors or not selectors then
        return
    end
    ngx.log(ngx.INFO, "[WAF] check selectors")

    local ngx_var_uri = ngx.var.uri
    for i, sid in ipairs(ordered_selectors) do
        local selector = selectors[sid]
        if selector and selector.enable == true then
            local selector_pass
            if selector.type == 0 then -- 全流量选择器
                selector_pass = true
            else
                selector_pass = judge_util.judge_selector(selector, "waf")-- selector judge
            end

            if selector_pass then
                if selector.handle and selector.handle.log == true then
                    ngx.log(ngx.INFO, "[WAF][PASS-SELECTOR:", sid, "] ", ngx_var_uri)
                end

                local stop = filter_rules(sid, "waf", ngx_var_uri)
                local selector_continue = selector.handle and selector.handle.continue
                if stop or not selector_continue then -- 不再执行此插件其他逻辑
                    return
                end
            else
                if selector.handle and selector.handle.log == true then
                    ngx.log(ngx.INFO, "[WAF][NOT-PASS-SELECTOR:", sid, "] ", ngx_var_uri)
                end
            end
        end
    end

end

return WAFHandler
