## api 调用统计插件

若开启了规则统计功能，使用之前需要在OpenResty配置文件中添加以下配置项：
```
lua_shared_dict api_status 10m;
```

- 每一分钟 把统计的数据插入到数据库
- 统计每一个api 的请求情况，数据存放在nginx shared dict
- 通过dashboard 查看api 请求曲线
