#!/bin/bash

# 定义常量
AGENT_DIR=~/nezha/agent
VERSION_FILE="${AGENT_DIR}/version.info"
CONFIG_FILE="${AGENT_DIR}/config.yml"
START_SCRIPT="${AGENT_DIR}/start-agent.sh"
LOG_FILE="${AGENT_DIR}/agent.log"

# 检查是否已安装
check_install() {
    if [ -f "${START_SCRIPT}" ]; then
        echo "哨兵已安装, 退出安装"
        exit 1
    fi
}

# 检查进程是否运行
check_process() {
    if pgrep -f "nezha-agent" > /dev/null; then
        return 0  # 进程正在运行
    else
        return 1  # 进程未运行
    fi
}

# 检查必要参数
check_params() {
    local params_complete=false

    while [ "$params_complete" = false ]; do
        if [ -z "${NEZHA_SERVER}" ] || [ -z "${NEZHA_PORT}" ] || [ -z "${NEZHA_KEY}" ]; then
            [ -z "${NEZHA_SERVER}" ] && read -p "请输入面板域名(必填): " NEZHA_SERVER
            [ -z "${NEZHA_PORT}" ] && read -p "请输入面板端口(必填): " NEZHA_PORT
            [ -z "${NEZHA_KEY}" ] && read -p "请输入面板密钥(必填): " NEZHA_KEY

            if [ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ]; then
                params_complete=true
                # 如果是通过交互输入完成的必填项, 让用户选择版本
                if [ -z "$VERSION" ]; then
                    local version_valid=false
                    while [ "$version_valid" = false ]; do
                        read -p "请输入安装的版本号(例如: v1.1.0 直接回车安装最新v1版本): " VERSION
                        [ -z "$VERSION" ] && VERSION="v1"

                        # 检查版本号是否存在
                        version_exists=$(check_version "$VERSION")

                        if [ "$version_exists" = "true" ]; then
                            version_valid=true
                        else
                            echo "版本号 $VERSION 不存在, 请重新输入"
                            VERSION=""
                        fi
                    done
                fi
            else
                echo "必要参数不能为空, 请重新输入"
            fi
        else
            params_complete=true
            # 如果必填项都通过参数传入且完整, 但未指定版本, 则默认使用 v0 最新版
            if [ -z "$VERSION" ]; then
                VERSION="v0"
            fi
        fi
    done
}

# 获取最新版本号
get_latest_version() {
    local latest_version=""
    if [ "$1" = "v0" ]; then
        latest_version="v0.20.5"
    elif [ "$1" = "v1" ]; then
        latest_version=$(curl -s https://api.github.com/repos/nezhahq/agent/releases/latest | grep "tag_name" | cut -d'"' -f4)
        if [ -z "$latest_version" ]; then
            latest_version="v1.1.0"
        fi
    fi
    echo "$latest_version"
}

# 检查版本号是否存在
check_version() {
    local version=$1
    local exists=false

    if [ "$version" = "v0" ] || [ "$version" = "v1" ]; then
        exists=true
    else
        # 通过GitHub API检查版本是否存在
        local response=$(curl -s "https://api.github.com/repos/nezhahq/agent/releases/tags/${version}")
        if ! echo "$response" | grep -q "Not Found"; then
            exists=true
        fi
    fi

    echo "$exists"
}

# 创建版本信息文件
create_version_info() {
    local install_version=$1
    local major_version=$2
    
    cat > "${VERSION_FILE}" << EOF
INSTALL_VERSION=${install_version}
MAJOR_VERSION=${major_version}
EOF
}

# 创建配置文件(仅v1版本需要)
create_config() {
    local server=$1
    local secret=$2
    
    cat > "${CONFIG_FILE}" << EOF
client_secret: ${secret}
debug: true
disable_auto_update: true
disable_command_execute: true
disable_force_update: true
disable_nat: false
disable_send_query: false
gpu: false
insecure_tls: false
ip_report_period: 1800
report_delay: 3
server: ${server}
skip_connection_count: false
skip_procs_count: false
temperature: false
tls: false
use_gitee_to_upgrade: false
use_ipv6_country_code: false
uuid: $(uuidgen)
EOF
}

# 创建启动脚本
create_start_script() {
    local major_version=$1
    local server=$2
    local port=$3
    local key=$4

    if [ "$major_version" = "v0" ]; then
        mkdir -p ${AGENT_DIR}/tmp
        # v0版本启动脚本
        cat > "${START_SCRIPT}" << EOF
#!/bin/sh
export TMPDIR=${AGENT_DIR}/tmp
nohup ${AGENT_DIR}/nezha-agent -s ${server}:${port} -p ${key} -d --report-delay 3 --disable-auto-update --disable-force-update --disable-command-execute >> ${LOG_FILE} 2>&1 &
EOF
    else
        # v1版本启动脚本
        cat > "${START_SCRIPT}" << EOF
#!/bin/sh
cd ${AGENT_DIR}
nohup ./nezha-agent -c config.yml >> ${LOG_FILE} 2>&1 &
EOF
    fi

    chmod +x "${START_SCRIPT}"
}

# 安装v0版本
install_v0() {
    # 创建启动脚本
    create_start_script "v0" "${NEZHA_SERVER}" "${NEZHA_PORT}" "${NEZHA_KEY}"

    # 保存版本信息
    create_version_info "${INSTALL_VERSION}" "${MAJOR_VERSION}"

    # 赋予执行权限
    chmod +x ${AGENT_DIR}/nezha-agent

    # 启动服务
    ${START_SCRIPT}

    echo "nezha-agent ${INSTALL_VERSION} 安装并启动成功!"
}

# 安装v1版本
install_v1() {
    # 创建配置文件(v1特有的yaml配置)
    create_config "${NEZHA_SERVER}:${NEZHA_PORT}" "${NEZHA_KEY}"

    # 创建启动脚本
    create_start_script "v1" "${NEZHA_SERVER}" "${NEZHA_PORT}" "${NEZHA_KEY}"

    # 保存版本信息
    create_version_info "${INSTALL_VERSION}" "${MAJOR_VERSION}"

    # 赋予执行权限
    chmod +x ${AGENT_DIR}/nezha-agent

    # 启动服务
    ${START_SCRIPT}

    echo "nezha-agent ${INSTALL_VERSION} 安装并启动成功!"
}

# 启动服务
start_agent() {
    if check_process; then
        echo "nezha-agent 已在运行中"
        return
    fi
    
    if [ ! -f "${START_SCRIPT}" ]; then
        echo "未找到启动脚本, 请先安装 nezha-agent"
        exit 1
    fi
    
    ${START_SCRIPT}
    echo "nezha-agent 启动成功"
}

# 停止服务
stop_agent() {
    if ! check_process; then
        echo "nezha-agent 未在运行"
        return
    fi
    
    pkill -f "nezha-agent"
    echo "nezha-agent 已停止"
}

# 重启服务
restart_agent() {
    stop_agent
    sleep 1
    start_agent
}

# 查看运行状态
status_agent() {
    if [ ! -f "${VERSION_FILE}" ]; then
        echo "未找到版本信息, 请先安装 nezha-agent"
        exit 1
    fi
    
    # 加载版本信息
    source "${VERSION_FILE}"
    
    echo "安装版本: $INSTALL_VERSION"
    echo "主版本: $MAJOR_VERSION"
    
    if check_process; then
        echo "运行状态: 运行中"
        pid=$(pgrep -f "nezha-agent")
        echo "进程ID: $pid"
    else
        echo "运行状态: 未运行"
    fi
}

# 卸载服务
uninstall_agent() {
    # 先停止服务
    if check_process; then
        stop_agent
        sleep 1
    fi
    
    # 删除安装目录
    if [ -d "${AGENT_DIR}" ]; then
        rm -rf "${AGENT_DIR}"
        echo "nezha-agent 卸载成功"
        echo "如需重新安装, 请运行: "
        echo "  直接安装: $0 install <面板域名> <面板端口> <密钥> [版本]"
        echo "  交互安装: $0 install"
    else
        echo "未找到安装目录"
    fi
}

# 查看日志（修复换行问题）
view_log() {
    if [ ! -f "${LOG_FILE}" ]; then
        echo "未找到日志文件"
        exit 1
    fi
    
    # 使用less查看日志，保留换行格式
    if [ -z "$1" ]; then
        tail -n 100 "${LOG_FILE}" | less -R
    else
        tail -n "$1" "${LOG_FILE}" | less -R
    fi
}

# 主函数
main() {
    case "$1" in
        "install_agent")
            shift  # 移除第一个参数
            # 检查是否已安装
            check_install
            
            # 获取参数
            NEZHA_SERVER=$1
            NEZHA_PORT=$2
            NEZHA_KEY=$3
            VERSION=$4
            
            # 检查必要参数
            check_params
            
            # 确定安装版本
            INSTALL_VERSION=""
            MAJOR_VERSION=""
            
            if [ -z "$VERSION" ]; then
                INSTALL_VERSION=$(get_latest_version "v1")
                MAJOR_VERSION="v1"
            else
                if [ "$VERSION" = "v0" ]; then
                    INSTALL_VERSION=$(get_latest_version "v0")
                    MAJOR_VERSION="v0"
                elif [ "$VERSION" = "v1" ]; then
                    INSTALL_VERSION=$(get_latest_version "v1")
                    MAJOR_VERSION="v1"
                else
                    INSTALL_VERSION=$VERSION
                    if [[ $VERSION =~ ^v0 ]]; then
                        MAJOR_VERSION="v0"
                    else
                        MAJOR_VERSION="v1"
                    fi
                fi
            fi
            
            echo "将安装 nezha-agent $INSTALL_VERSION   主版本: $MAJOR_VERSION"
            
            # 创建文件夹
            mkdir -p "${AGENT_DIR}"
            
            # 进入文件夹
            cd "${AGENT_DIR}"
            
            # 下载 nezha-agent-freebsd 的包
            wget "https://github.com/nezhahq/agent/releases/download/$INSTALL_VERSION/nezha-agent_freebsd_amd64.zip"
            if [ $? -ne 0 ]; then
                echo "下载 nezha-agent $INSTALL_VERSION 版本失败..."
                exit 1
            fi
            
            # 解压包
            unzip "nezha-agent_freebsd_amd64.zip"
            
            # 删除压缩包
            rm nezha-agent_freebsd_amd64.zip
            
            # 根据主版本执行不同的安装步骤
            if [ "$MAJOR_VERSION" = "v0" ]; then
                install_v0
            else
                install_v1  # 由你实现v1版本的安装步骤
            fi
            ;;
        "uninstall_agent")
            uninstall_agent
            ;;
        "start_agent")
            start_agent
            ;;
        "stop_agent")
            stop_agent
            ;;
        "restart_agent")
            restart_agent
            ;;
        "status_agent")
            status_agent
            ;;
        "log_agent")
            view_log $2  # 可以指定查看的行数
            ;;
        *)
            echo "使用方法: "
            echo "  安装 nezha-agent: $0 install_agent <面板域名> <面板端口> <密钥> [版本]"
            echo "     - 直接安装, 面板域名、面板端口、密钥 为必填, 版本号可选, 不传的话默认安装最新 v1 版本"
            echo "     - 面��交互安装, 直接 $0 install_agent 不传参数, 会自动交互输入面板域名、面板端口、密钥, 版本号等信息"
            echo "  卸载 nezha-agent: $0 uninstall_agent"
            echo "  启动 nezha-agent: $0 start_agent"
            echo "  停止 nezha-agent: $0 stop_agent"
            echo "  重启 nezha-agent: $0 restart_agent"
            echo "  状态 nezha-agent: $0 status_agent"
            echo "  查看日志: $0 log_agent [行数]"
            echo "    - $0 log_agent         查看最后100行日志"
            echo "    - $0 log_agent 50      查看最后50行日志"
            exit 1
            ;;
    esac
}

main "$@"