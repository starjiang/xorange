
## 使用方法

- 解析dynamic_upstream 传递过来的参数，并根据匹配的upstream 进行负载均衡
- 负载均衡支持rr 轮询，随机权重，ip_hash
- 通过nginx 的orange_upstream 进行负载转发
- 默认转发到127.0.0.1:8001