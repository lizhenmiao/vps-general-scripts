# vps-general-scripts
centos / ubuntu / debian / redhat / freebsd 等系统的一些常用软件安装脚本, 支持中英文

## 使用方法

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
