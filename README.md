# xorange是一个基于OpenResty的API网关。除Nginx的基本功能外，它还可用于API监控、访问控制(鉴权、WAF)、流量筛选、访问限速、AB测试、静/动态分流等。它有以下特性：
* 提供了一套默认的Dashboard用于动态管理各种功能和配置
* 支持节点管理，节点数据同步
* 提供了API接口用于实现第三方服务(如个性化运维需求、第三方Dashboard等)
* 可根据规范编写自定义插件扩展Orange功能
* 高性能，打开常用的插件，对吞吐量有10% 的损失
* xorange 基于orange,源项目地址 https://github.com/sumory/orange
## 目前插件列表，以及相关功能介绍
* header 插件，可以根据规则添加请求，或者返回http头
* monitor 插件，可以根据规则，进行http 请求的实时监控
* api_stat 插件，对所有api 进行统计，图表展示
* rewrite 插件，实现 url rewrite
* redirect 插件，实现 url redirect
* dynamic_upstream 插件，根据规则实现请求分流，转发，负载均衡，AB Testing
* balancer 插件，管理up_stream 池，实现负载均衡算法
* rate_limiting 插件，根据规则，实现频率限制
* property_rate_limiting 插件，基于变量提取的频率限制插件
* waf 插件，web应用防火墙，根据规则，IP地址进行访问控制
* kafka 插件，记录nginx access_log 到kafka

## 在orange项目v0.7版本基础上，进行开发改进，去掉一些插件，修复一些问题，达到生产环境可用
* 去除divide,kvstore,persist 等应用场景使用较少或功能重复插件
* 添加了api 统计插件，可方便观察各个api 各时段数据及曲线图
* 除了cosocket 依赖需要luarocks 安装外，其余依赖以源码方式集成到项目中
* dashboard 去除了相应的模块
* 强化了 balancer 插件，去除了resty.dns.client 的依赖，增加轮询，随机权重，ip_hash 负载均衡算法
* 强化kafka nginx 日志插件，解决当qps 很大时内存疯涨问题
* 强化header 插件，不但可以添加请求http头，还可以增加返回http头
* 强化waf 插件，增加IP 黑白名单控制
* 优化了规则每次读取性能，不需要每次都需要json反序列化，提升性能
## 安装
* git clone 项目git地址
* 复制项目到 /usr/local/orange 下
* 项目依赖openresty，所以需要安装openresty
* 安装luasocket luarocks install luasocket 注意luarocks 必须是依赖openresty luajit
* luarocks 安装（已经安装了，忽略）
   * wget http://luarocks.github.io/luarocks/releases/luarocks-3.0.4.tar.gz
   * tar -xzvf luarocks-3.0.4.tar.gz
   * ./configure --prefix=/usr/local/openresty/luajit     --with-lua=/usr/local/openresty/luajit/     --lua-suffix=jit     --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
* 导入/usr/local/orange/install/orange.sql 到mysql 数据库
* dashboard默认用户名/密码 admin/orange_admin
## 修改配置文件

Orange有**两个**配置文件，一个是`conf/orange.conf`，用于配置插件、存储方式和内部集成的默认Dashboard，另一个是`conf/nginx.conf`用于配置Nginx.
orange.conf的配置如下，请按需修改:

```javascript
{
    "plugins": [ //可用的插件列表，若不需要可从中删除，系统将自动加载这些插件的开放API并在7777端口暴露
        "stat",
        "monitor",
        ".."
    ],

    "store": "mysql",//目前仅支持mysql存储
    "store_mysql": { //MySQL配置
        "timeout": 5000,
        "connect_config": {//连接信息，请修改为需要的配置
            "host": "127.0.0.1",
            "port": 3306,
            "database": "orange",
            "user": "root",
            "password": "",
            "max_packet_size": 1048576
        },
        "pool_config": {
            "max_idle_timeout": 10000,
            "pool_size": 3
        }
    },

    "dashboard": {//默认的Dashboard配置.
        "auth": false, //设为true，则需用户名、密码才能登录Dashboard,默认的用户名和密码为admin/orange_admin
        "session_secret": "y0ji4pdj61aaf3f11c2e65cd2263d3e7e5", //加密cookie用的盐，自行修改即可
        "whitelist": [//不需要鉴权的uri，如登录页面，无需修改此值
            "^/auth/login$",
            "^/error/$"
        ]
    },

    "api": {//API server配置
        "auth_enable": true,//访问API时是否需要授权
        "credentials": [//HTTP Basic Auth配置，仅在开启auth_enable时有效，自行添加或修改即可
            {
                "username":"api_username",
                "password":"api_password"
            }
        ]
    }
}
```

conf/nginx.conf里是一些nginx相关配置，请自行检查并按照实际需要更改或添加配置，特别注意以下几个配置：

- lua_package_path：需要根据本地环境配置适当修改
- resolver：DNS解析

## 启动
* /usr/local/orange/bin/orange start/restart/reload
## 管理地址
* http://安装的机器ip:9999
## api 调用地址
* http://安装的机器ip:7777
## 后续开发迭代计划
* 支持ssl 证书管理
* 增强waf 功能,支持ip 列表，ip网段
* 增强性能（目前来看规则匹配，比较耗cpu）

