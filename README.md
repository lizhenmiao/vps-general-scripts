# vps-general-scripts
centos / ubuntu / debian / redhat / freebsd 等系统的一些常用软件安装脚本, 支持中英文

## 使用方法

### 现在 nezha-agent 更新了 v1 版本, 启动命令有所不同, 直接在代码中先写死获取 v0 最后一个版本了, 也可以使用以下命令下载安装 v0 版本的 nezha-agent

```bash
cd ~/nezha && rm nezha-agent && wget "https://github.com/nezhahq/agent/releases/download/v0.20.5/nezha-agent_freebsd_amd64.zip" && unzip "nezha-agent_freebsd_amd64.zip" && rm nezha-agent_freebsd_amd64.zip && chmod +x nezha-agent
```

### 国外 vps

#### 用 curl 静默下载

```bash
curl -sS -O https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/install_services.sh && chmod +x install_services.sh && ./install_services.sh
```

#### 用 wget 静默下载

```bash
wget -q https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/install_services.sh && chmod +x install_services.sh && ./install_services.sh
```

### 国内 vps 或者访问 github 慢, 可以使用代理加速服务

```bash
curl -sS -O https://ghp.ci/https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/install_services.sh && chmod +x install_services.sh && ./install_services.sh
```

```bash
wget -q https://ghp.ci/https://raw.githubusercontent.com/lizhenmiao/vps-general-scripts/main/install_services.sh && chmod +x install_services.sh && ./install_services.sh
```
