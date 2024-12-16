# Serv00 安装脚本

## 安装 哪吒 agent
1. 直接安装(推荐)

```bash
curl -L https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/serv00/install_nezha.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent ip port secret version
```
> ip: 哪吒 dashboard 的 ip, 必填

> port: 哪吒 dashboard 的 grpc port, 必填

> secret: 哪吒 dashboard 创建完服务器给的 secret, 必填

> version: 哪吒 agent 的版本, 选填, 值可以为 v0 或 v1 或者是具体版本号, 例如 v1.1.0, 不填的话默认为 v0.20.5 版本

2. 面板交互输入安装
```bash
curl -L https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/serv00/install_nezha.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent
```

> 之后按照提示输入内容回车运行即可
