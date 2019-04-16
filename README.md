# Orange是一个基于OpenResty的API网关。除Nginx的基本功能外，它还可用于API监控、访问控制(鉴权、WAF)、流量筛选、访问限速、AB测试、静/动态分流等。它有以下特性：
* 提供了一套默认的Dashboard用于动态管理各种功能和配置
* 提供了API接口用于实现第三方服务(如个性化运维需求、第三方Dashboard等)
* 可根据规范编写自定义插件扩展Orange功能

* orange 源项目地址 https://github.com/sumory/orange
## 在源项目基础上去掉一些插件，修复一些问题
* 去除divide,kvstore 插件
* 强化persist 插件，添加了api 统计，曲线图
* 除了socket 依赖需要luarocks 安装外，其余依赖以源码方式集成到项目中
* dashboard 去除了相应的模块
* 强化了 balancer 插件，去除了balancer 的依赖，增加轮询，随机权重，ip_hash 负载均衡算法
## 安装
* git clone 项目git地址
* 复制项目到 /usr/local/orange 下
* 项目依赖openresty，所以需要安装openresty
* 安装luarocks install https://luarocks.org/manifests/luarocks/luasocket-3.0rc1-2.rockspec 注意luarocks 必须是依赖openresty luajit
* luarocks 安装（已经安装了，忽略）
   * wget http://luarocks.github.io/luarocks/releases/luarocks-3.0.4.tar.gz
   * tar -xzvf luarocks-3.0.4.tar.gz
   * ./configure --prefix=/usr/local/openresty/luajit     --with-lua=/usr/local/openresty/luajit/     --lua-suffix=jit     --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
* 导入/usr/local/orange/install/orange.sql 到mysql 数据库
* 默认用户名/密码 admin/orange_admin
## 启动
* /usr/local/orange/bin/orange start/restart/reload
## 管理地址
* http://安装的机器ip:9999
## api 调用地址
* http://安装的机器ip:7777

