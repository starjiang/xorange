### 流量统计插件

使用之前需要在OpenResty配置文件中添加以下配置项：

```
lua_shared_dict status 1m;
```

shared dict的大小需根据实际应用配置。

