# Orange 基于openresty的api管理,负载，分发，监控，频率限制，鉴权认证管理平台
* orange 源项目地址 https://github.com/sumory/orange
## 在源项目基础上去掉一些插件，修复一些问题
* 去除divide,kvstore 插件
* 强化persist 插件，添加了api 统计，曲线图
* 除了socket 依赖需要luarocks 安装外，其余依赖以源码方式集成到项目中
* dashboard 去除了相应的模块
## 安装
* git clone 项目git地址
* 复制项目到 /usr/local/orange 下
* 安装luarocks install https://luarocks.org/manifests/luarocks/luasocket-3.0rc1-2.rockspec 注意luarocks 必须是依赖openresty luajit
* luarocks 安装（已经安装了，忽略）
   * wget http://luarocks.github.io/luarocks/releases/luarocks-3.0.4.tar.gz
   * tar -xzvf luarocks-3.0.4.tar.gz
   * ./configure --prefix=/usr/local/openresty/luajit     --with-lua=/usr/local/openresty/luajit/     --lua-suffix=jit     --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
## 启动
* /usr/local/orange/bin/orange start/restart/reload
## 管理地址
* http://安装的机器ip:9999
## api 调用地址
* http://安装的机器ip:7777

