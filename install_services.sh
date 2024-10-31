#!/bin/bash

# Declare associative arrays for English and Chinese translations
declare -A lang_en
declare -A lang_cn

# English translations
lang_en=(
    ["choose_option"]="Please choose an option:"
    ["invalid_lang_option"]="Invalid option, defaulting to Chinese."
    ["address"]="Address"
    ["detected_os"]="Detected OS"
    ["install_agent"]="Install Nezha agent"
    ["check_status"]="Check Nezha agent status"
    ["uninstall_agent"]="Uninstall Nezha agent"
    ["start_agent"]="Start Nezha agent"
    ["stop_agent"]="Stop Nezha agent"
    ["restart_agent"]="Restart Nezha agent"
    ["exit"]="Exit"
    ["exit_message"]="Exiting. You can run ./install_services.sh to display this menu again."
    ["are_you_sure"]="Are you sure you want to proceed? (y/n): "
    ["cancelled"]="Action cancelled."
    ["invalid_option"]="Invalid option."
    ["already_running"]="Nezha agent is already running."
    ["starting_agent"]="Starting Nezha agent..."
    ["stopping_agent"]="Stopping Nezha agent..."
    ["uninstalling_agent"]="Uninstalling Nezha agent..."
    ["installation_completed"]="Nezha agent installation completed and connected to dashboard at"
    ["check_log"]="Check the log file at ~/nezha/agent.log for more details."
    ["failed_start"]="Failed to start Nezha agent after 5 attempts."
    ["nginx_installed"]="Nginx is already installed."
    ["installing_nginx"]="Installing Nginx on"
    ["uninstalling_nginx"]="Uninstalling Nginx on"
    ["nginx_not_supported"]="Nginx installation not supported for"
    ["nginx_not_installed"]="Nginx is not installed."
    ["docker_already_installed"]="Docker is already installed."
    ["installing_docker"]="Installing Docker on"
    ["uninstalling_docker"]="Uninstalling Docker on"
    ["docker_not_supported"]="Docker installation not supported for"
    ["docker_not_installed"]="Docker is not installed."
    ["set_mirrors"]="Setting mirrors for"
    ["mirrors_not_supported"]="Setting mirrors not supported for"
    ["docker_binary_location"]="Docker binary location"
    ["docker_root_location"]="Docker root directory"
    ["nginx_binary_location"]="Nginx binary location"
    ["nginx_config_file"]="Nginx configuration file"
    ["nginx_config_file_not_found"]="Nginx configuration file location not found."
    ["install_nginx"]="Install Nginx"
    ["uninstall_nginx"]="Uninstall Nginx"
    ["check_nginx_info"]="Check Nginx installation info"
    ["install_docker"]="Install Docker"
    ["uninstall_docker"]="Uninstall Docker"
    ["check_docker_info"]="Check Docker installation info"
    ["set_mirrors_cn"]="Set mirrors for China"
    ["nezha_agent_not_installed"]="Nezha agent is not installed."
    ["terminated_agent"]="Terminated agent.sh with PID"
    ["terminated_nezha_agent"]="Terminated nezha-agent with PID"
    ["nezha_agent_not_running"]="Nezha agent is not running."
    ["enter_domain"]="Enter the Nezha dashboard domain"
    ["enter_port"]="Enter the Nezha dashboard port"
    ["enter_password"]="Enter the password provided by Nezha dashboard"
    ["get_latest_version"]="Getting latest version..."
    ["failed_get_latest_version"]="Failed to fetch the latest version."
    ["nezha_agent_installed"]="Nezha agent is already installed."
    ["nezha_agent_running"]="Nezha agent is currently running."
    ["nezha_agent_installed_not_running"]="Nezha agent is installed but not running."
    ["nezha_agent_uninstalled"]="Nezha agent uninstallation completed."
    ["unsupported_os"]="This script does not support your operating system."
    ["unknown_os"]="This script is designed to run on Linux or FreeBSD systems."
    ["attempt_failed"]="Attempt %d failed, retrying..."
)

# Chinese translations
lang_cn=(
    ["choose_option"]="请选择一个选项："
    ["invalid_lang_option"]="无效的选项，默认为中文"
    ["address"]="地址"
    ["detected_os"]="检测到的操作系统"
    ["install_agent"]="安装哪吒探针 agent"
    ["check_status"]="检查哪吒探针 agent 状态"
    ["uninstall_agent"]="卸载哪吒探针 agent"
    ["start_agent"]="启动哪吒探针 agent"
    ["stop_agent"]="停止哪吒探针 agent"
    ["restart_agent"]="重启哪吒探针 agent"
    ["exit"]="退出"
    ["exit_message"]="已退出。之后可以运行 ./install_services.sh 来显示此菜单。"
    ["are_you_sure"]="你确定要继续吗？(y/n): "
    ["cancelled"]="操作取消。"
    ["invalid_option"]="无效选项。"
    ["already_running"]="哪吒探针 agent已经在运行。"
    ["starting_agent"]="正在启动哪吒探针 agent ..."
    ["stopping_agent"]="正在停止哪吒探针 agent ..."
    ["uninstalling_agent"]="正在卸载哪吒探针 agent ..."
    ["installation_completed"]="哪吒探针 agent 安装完成并连接到面板"
    ["check_log"]="检查日志文件 ~/nezha/agent.log 以获取更多详细信息。"
    ["failed_start"]="启动哪吒探针 agent 失败，经过5次尝试。"
    ["nginx_installed"]="Nginx 已经安装。"
    ["installing_nginx"]="正在安装 Nginx 于"
    ["uninstalling_nginx"]="正在卸载 Nginx 于"
    ["nginx_not_supported"]="不支持在此系统上安装 Nginx"
    ["nginx_not_installed"]="Nginx 未安装。"
    ["docker_already_installed"]="Docker 已经安装。"
    ["installing_docker"]="正在安装 Docker 于"
    ["uninstalling_docker"]="正在卸载 Docker 于"
    ["docker_not_supported"]="不支持在此系统上安装 Docker"
    ["docker_not_installed"]="Docker 未安装。"
    ["set_mirrors"]="设置镜像源为"
    ["mirrors_not_supported"]="不支持在此系统上设置镜像源"
    ["docker_binary_location"]="Docker 二进制文件位置"
    ["docker_root_location"]="Docker 根目录"
    ["nginx_binary_location"]="Nginx 二进制文件位置"
    ["nginx_config_file"]="Nginx 配置文件"
    ["nginx_config_file_not_found"]="未找到 Nginx 配置文件位置"
    ["install_nginx"]="安装 Nginx"
    ["uninstall_nginx"]="卸载 Nginx"
    ["check_nginx_info"]="检查 Nginx 安装信息"
    ["install_docker"]="安装 Docker"
    ["uninstall_docker"]="卸载 Docker"
    ["check_docker_info"]="检查 Docker 安装信息"
    ["set_mirrors_cn"]="设置中国镜像源"
    ["nezha_agent_not_installed"]="哪吒探针 agent 未安装。"
    ["terminated_agent"]="终止 agent.sh 进程 PID"
    ["terminated_nezha_agent"]="终止 nezha-agent 进程 PID"
    ["nezha_agent_not_running"]="哪吒探针 agent 未运行。"
    ["enter_domain"]="请输入哪吒面板域名"
    ["enter_port"]="请输入哪吒面板端口"
    ["enter_password"]="请输入哪吒面板提供的密码"
    ["get_latest_version"]="获取最新版本中..."
    ["failed_get_latest_version"]="获取最新版本失败。"
    ["nezha_agent_installed"]="哪吒探针 agent 已安装。"
    ["nezha_agent_running"]="哪吒探针 agent 已运行。"
    ["nezha_agent_installed_not_running"]="哪吒探针 agent 已安装，但未运行。"
    ["nezha_agent_uninstalled"]="哪吒探针 agent 已卸载。"
    ["unsupported_os"]="不支持此操作系统。"
    ["unknown_os"]="此脚本适用于 Linux 或 FreeBSD 系统。"
    ["attempt_failed"]="第 %d 次尝试失败，正在重试..."
)

# Set default language
current_lang="cn"

# Function to select language
select_language() {
    echo "Select language / 选择语言:"
    echo "1) English"
    echo "2) 中文"
    read -p "$(get_text "choose_option") [1-2]: " lang_choice
    case $lang_choice in
        1)
            current_lang="en"
            ;;
        2)
            current_lang="cn"
            ;;
        *)
            echo "$(get_text "invalid_lang_option")"
            current_lang="cn"
            ;;
    esac
}

# Function to get translated text with optional formatting
get_text() {
    local key=$1
    shift  # Remove the first argument (key) from the argument list
    local text
    if [ "$current_lang" == "en" ]; then
        text="${lang_en[$key]}"
    else
        text="${lang_cn[$key]}"
    fi
    # If there are additional arguments, use them for formatting
    if [ $# -gt 0 ]; then
        printf "$text" "$@"
    else
        echo "$text"
    fi
}

# Function to detect the operating system and gather network information
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
            VERSION=$VERSION_ID
        elif type lsb_release >/dev/null 2>&1; then
            OS=$(lsb_release -si)
            VERSION=$(lsb_release -sr)
        elif [ -f /etc/lsb-release ]; then
            . /etc/lsb-release
            OS=$DISTRIB_ID
            VERSION=$DISTRIB_RELEASE
        elif [ -f /etc/debian_version ]; then
            OS="Debian"
            VERSION=$(cat /etc/debian_version)
        elif [ -f /etc/redhat-release ]; then
            OS="RedHat"
            VERSION=$(cat /etc/redhat-release)
        else
            OS="Unknown"
            VERSION="Unknown"
        fi

        # Get network information on Linux
        IPV4=$(hostname -I | awk '{print $1}')
        IPV6=$(hostname -I | awk '{print $2}')
        MAC=$(ip link show | awk '/ether/ {print $2}' | head -n 1)

        echo "IPv4 $(get_text "address"): $IPV4 IPv6 $(get_text "address"): $IPV6 MAC $(get_text "address"): $MAC"

    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        OS="FreeBSD"
        VERSION=$(uname -r)
    else
        OS="Unsupported"
        VERSION="Unknown"
    fi
    echo "$(get_text "detected_os"): $OS $VERSION"
    echo ""
}

# Function to check if Nginx is installed
is_nginx_installed() {
    command -v nginx >/dev/null 2>&1
}

# Function to install Nginx
install_nginx() {
    if is_nginx_installed; then
        echo "$(get_text "nginx_installed")"
    else
        case "$OS" in
            ubuntu|debian)
                echo "$(get_text "installing_nginx") $OS..."
                sudo apt update
                sudo apt install -y nginx
                ;;
            centos|redhat)
                echo "$(get_text "installing_nginx") $OS..."
                sudo yum install -y epel-release
                sudo yum install -y nginx
                ;;
            *)
                echo "$(get_text "nginx_not_supported") $OS"
                ;;
        esac
    fi
}

# Function to uninstall Nginx
uninstall_nginx() {
    if is_nginx_installed; then
        case "$OS" in
            ubuntu|debian)
                echo "$(get_text "uninstalling_nginx") $OS..."
                sudo systemctl stop nginx
                sudo systemctl disable nginx
                sudo apt remove -y nginx nginx-common nginx-core
                sudo apt purge -y nginx nginx-common nginx-core
                sudo rm -rf /etc/nginx /usr/sbin/nginx /var/lib/nginx /var/log/nginx /var/www/html
                ;;
            centos|redhat)
                echo "$(get_text "uninstalling_nginx") $OS..."
                sudo systemctl stop nginx
                sudo systemctl disable nginx
                sudo yum remove -y nginx
                sudo rm -rf /etc/nginx /usr/sbin/nginx /var/lib/nginx /var/log/nginx /var/www/html
                ;;
            *)
                echo "$(get_text "nginx_not_supported") $OS"
                ;;
        esac
    else
        echo "$(get_text "nginx_not_installed")"
    fi
}

# Function to check Nginx installation info
info_nginx() {
    if is_nginx_installed; then
        echo "$(get_text "nginx_installed")"
        echo "$(get_text "nginx_binary_location"): $(command -v nginx)"
        if [ -f /etc/nginx/nginx.conf ]; then
            echo "$(get_text "nginx_config_file"): /etc/nginx/nginx.conf"
        elif [ -f /usr/local/nginx/conf/nginx.conf ]; then
            echo "$(get_text "nginx_config_file"): /usr/local/nginx/conf/nginx.conf"
        else
            echo "$(get_text "nginx_config_file_not_found")"
        fi
    else
        echo "$(get_text "nginx_not_installed")"
    fi
}

# Function to check if Docker is installed
is_docker_installed() {
    command -v docker >/dev/null 2>&1
}

# Function to install Docker
install_docker() {
    if is_docker_installed; then
        echo "$(get_text "docker_already_installed")"
    else
        case "$OS" in
            ubuntu|debian)
                echo "$(get_text "installing_docker") $OS..."
                sudo apt update
                sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$OS $(lsb_release -cs) stable"
                sudo apt update
                sudo apt install -y docker-ce
                ;;
            centos|redhat)
                echo "$(get_text "installing_docker") $OS..."
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                sudo yum install -y docker-ce docker-ce-cli containerd.io
                ;;
            *)
                echo "$(get_text "docker_not_supported") $OS"
                ;;
        esac
    fi
}

# Function to uninstall Docker
uninstall_docker() {
    if is_docker_installed; then
        case "$OS" in
            ubuntu|debian)
                echo "$(get_text "uninstalling_docker") $OS..."
                sudo systemctl stop docker
                sudo systemctl disable docker
                sudo apt remove -y docker-ce
                sudo apt purge -y docker-ce
                sudo rm -rf /var/lib/docker /etc/docker /var/run/docker.sock /usr/bin/docker
                ;;
            centos|redhat)
                echo "$(get_text "uninstalling_docker") $OS..."
                sudo systemctl stop docker
                sudo systemctl disable docker
                sudo yum remove -y docker-ce docker-ce-cli containerd.io
                sudo rm -rf /var/lib/docker /etc/docker /var/run/docker.sock /usr/bin/docker
                ;;
            *)
                echo "$(get_text "docker_not_supported") $OS"
                ;;
        esac
    else
        echo "$(get_text "docker_not_installed")"
    fi
}

# Function to check Docker installation info
info_docker() {
    if is_docker_installed; then
        echo "$(get_text "docker_already_installed")"
        echo "$(get_text "docker_binary_location"): $(command -v docker)"
        echo "$(get_text "docker_root_location"): $(docker info --format '{{ .DockerRootDir }}')"
    else
        echo "$(get_text "docker_not_installed")"
    fi
}

# Function to get user confirmation
confirm_action() {
    read -p "$(get_text "are_you_sure")" confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        return 0
    else
        echo "$(get_text "cancelled")"
        return 1
    fi
}

# Function to set mirrors for China
set_mirrors() {
    case "$OS" in
        ubuntu|debian)
            echo "$(get_text "set_mirrors") $OS..."
            sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list
            sudo apt update
            ;;
        centos|redhat)
            echo "$(get_text "set_mirrors") $OS..."
            sudo sed -i 's|mirror.centos.org|mirrors.aliyun.com|g' /etc/yum.repos.d/CentOS-Base.repo
            sudo yum clean all
            sudo yum makecache
            ;;
        *)
            echo "$(get_text "mirrors_not_supported") $OS"
            ;;
    esac
}

# Function to detect if the VPS is in China
is_vps_in_china() {
    local country=$(curl -s ipinfo.io | grep '"country":' | awk -F\" '{print $4}')
    if [[ "$country" == "CN" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to display the menu and handle user input
display_menu() {
    while true; do
        echo "$(get_text "choose_option")"
        echo "1) $(get_text "install_nginx")"
        echo "2) $(get_text "uninstall_nginx")"
        echo "3) $(get_text "check_nginx_info")"
        echo "4) $(get_text "install_docker")"
        echo "5) $(get_text "uninstall_docker")"
        echo "6) $(get_text "check_docker_info")"
        if [[ $is_china == 1 ]]; then
            echo "7) $(get_text "set_mirrors_cn")"
            echo "0) $(get_text "exit")"
            read -p "$(get_text "choose_option") [0-7]: " choice
        else
            echo "0) $(get_text "exit")"
            read -p "$(get_text "choose_option") [0-6]: " choice
        fi

        case $choice in
            1)
                if confirm_action; then
                    install_nginx
                fi
                ;;
            2)
                if confirm_action; then
                    uninstall_nginx
                fi
                ;;
            3)
                info_nginx
                ;;
            4)
                if confirm_action; then
                    install_docker
                fi
                ;;
            5)
                if confirm_action; then
                    uninstall_docker
                fi
                ;;
            6)
                info_docker
                ;;
            7)
                if [[ $is_china == 1 ]]; then
                    if confirm_action; then
                        set_mirrors
                    fi
                else
                    echo "$(get_text "invalid_option")"
                fi
                ;;
            0)
                echo "$(get_text "exit_message")"
                break
                ;;
            *)
                echo "$(get_text "invalid_option")"
                ;;
        esac
        echo
    done
}

# Function to get the latest version of Nezha agent from GitHub
get_latest_nezha_version() {
    curl -s https://api.github.com/repos/nezhahq/agent/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Function to get the PID of a process by name
get_freebsd_pid_by_name() {
    local process_name=$1
    local pid=$(pgrep -f "/$process_name")

    if [ -z "$pid" ]; then
        pid=$(ps aux | grep "/$process_name" | grep -v grep | awk '{print $2}')
    fi

    echo $pid
}

# Function to print the PIDs of Nezha agent scripts
print_nezha_agent_pids() {
    local agent_pid=$(get_freebsd_pid_by_name 'agent.sh')
    local nezha_agent_pid=$(get_freebsd_pid_by_name 'nezha-agent')
    echo "agent.sh PID: $agent_pid nezha-agent PID: $nezha_agent_pid"
}

# Function to check if Nezha agent is already installed on FreeBSD
is_freebsd_nezha_agent_installed() {
    [ -f ~/nezha/agent.sh ]
}

# Function to check if Nezha agent is running on FreeBSD
is_freebsd_nezha_agent_running() {
    [ -n "$(get_freebsd_pid_by_name 'agent.sh')" ] || [ -n "$(get_freebsd_pid_by_name 'nezha-agent')" ]
}

# Function to start Nezha agent on FreeBSD
start_freebsd_nezha_agent() {
    if is_freebsd_nezha_agent_installed; then
        if is_freebsd_nezha_agent_running; then
            echo "$(get_text "already_running")"
            print_nezha_agent_pids
            return
        fi

        echo "$(get_text "starting_agent")"
        nohup ~/nezha/agent.sh > /dev/null 2>&1 &

        # Try to start the agent up to 5 times
        for i in {1..5}; do
            sleep 2
            if is_freebsd_nezha_agent_running; then
                echo "$(get_text "installation_completed")"
                print_nezha_agent_pids
                return
            else
                echo "$(get_text "attempt_failed" $i)"
                nohup ~/nezha/agent.sh > /dev/null 2>&1 &
            fi
        done

        echo "$(get_text "failed_start")"
    else
        echo "$(get_text "nezha_agent_not_installed")"
    fi
}

# Function to stop Nezha agent on FreeBSD
stop_freebsd_nezha_agent() {
    if is_freebsd_nezha_agent_installed; then
        if is_freebsd_nezha_agent_running; then
            echo "$(get_text "stopping_agent")"
            print_nezha_agent_pids
            # Terminate the processes using their PIDs
            local agent_pid=$(get_freebsd_pid_by_name 'agent.sh')
            local nezha_agent_pid=$(get_freebsd_pid_by_name 'nezha-agent')
            if [ -n "$agent_pid" ]; then
                kill "$agent_pid"
                echo "$(get_text "terminated_agent") $agent_pid"
            fi
            if [ -n "$nezha_agent_pid" ]; then
                kill "$nezha_agent_pid"
                echo "$(get_text "terminated_nezha_agent") $nezha_agent_pid"
            fi
        else
            echo "$(get_text "nezha_agent_not_running")"
        fi
    else
        echo "$(get_text "nezha_agent_not_installed")"
    fi
}

# Function to restart Nezha agent on FreeBSD
restart_freebsd_nezha_agent() {
    stop_freebsd_nezha_agent
    start_freebsd_nezha_agent
}

# Function to install Nezha agent on FreeBSD
install_freebsd_nezha_agent() {
    if is_freebsd_nezha_agent_installed; then
        check_freebsd_nezha_agent_status
        return
    fi

    read -p "$(get_text "enter_domain"): " domain
    read -p "$(get_text "enter_port"): " port
    read -p "$(get_text "enter_password"): " password

    echo "$(get_text "get_latest_version")"
    local latest_version=$(get_latest_nezha_version)
    if [ -z "$latest_version" ]; then
        echo "$(get_text "failed_get_latest_version")"
        return
    fi

    mkdir -p ~/nezha ~/nezha_tmp
    cd ~/nezha
    wget "https://github.com/nezhahq/agent/releases/download/$latest_version/nezha-agent_freebsd_amd64.zip"
    unzip "nezha-agent_freebsd_amd64.zip"
    rm nezha-agent_freebsd_amd64.zip  # Remove the ZIP file after extraction

    cat > agent.sh << EOF
#!/bin/sh
export TMPDIR=~/nezha_tmp
~/nezha/nezha-agent -s $domain:$port -p $password -d >> ~/nezha/agent.log 2>&1
EOF

    chmod +x agent.sh
    chmod +x nezha-agent

    # Run the agent.sh script as a named task
    nohup ./agent.sh > /dev/null 2>&1 &

    # Try to start the agent up to 5 times
    for i in {1..5}; do
        sleep 2
        if is_freebsd_nezha_agent_running; then
            echo "$(get_text "installation_completed") $domain:$port."
            print_nezha_agent_pids
            echo "$(get_text "check_log")"
            return
        else
            echo "$(get_text "attempt_failed" $i)"
            nohup ./agent.sh > /dev/null 2>&1 &
        fi
    done

    echo "$(get_text "failed_start")"
}

# Function to check the status of Nezha agent on FreeBSD
check_freebsd_nezha_agent_status() {
    if is_freebsd_nezha_agent_installed; then
        echo "$(get_text "nezha_agent_installed")"
        if is_freebsd_nezha_agent_running; then
            echo "$(get_text "nezha_agent_running")"
            print_nezha_agent_pids
        else
            echo "$(get_text "nezha_agent_installed_not_running")"
        fi
    else
        echo "$(get_text "nezha_agent_not_installed")"
    fi
}

# Function to uninstall Nezha agent on FreeBSD
uninstall_freebsd_nezha_agent() {
    if is_freebsd_nezha_agent_installed; then
        if is_freebsd_nezha_agent_running; then
            stop_freebsd_nezha_agent
        fi
        echo "$(get_text "uninstalling_agent")"
        rm -rf ~/nezha ~/nezha_tmp
        echo "$(get_text "nezha_agent_uninstalled")"
    else
        echo "$(get_text "nezha_agent_not_installed")"
    fi
}

# Main script to handle FreeBSD menu
display_freebsd_menu() {
    while true; do
        echo "$(get_text "choose_option")"
        echo "1) $(get_text "install_agent")"
        echo "2) $(get_text "uninstall_agent")"
        echo "3) $(get_text "check_status")"
        echo "4) $(get_text "start_agent")"
        echo "5) $(get_text "stop_agent")"
        echo "6) $(get_text "restart_agent")"
        echo "0) $(get_text "exit")"
        read -p "$(get_text "choose_option") [0-6]: " choice

        case $choice in
            1)
                if confirm_action; then
                    install_freebsd_nezha_agent
                fi
                ;;
            2)
                if confirm_action; then
                    uninstall_freebsd_nezha_agent
                fi
                ;;
            3)
                check_freebsd_nezha_agent_status
                ;;
            4)
                if confirm_action; then
                    start_freebsd_nezha_agent
                fi
                ;;
            5)
                if confirm_action; then
                    stop_freebsd_nezha_agent
                fi
                ;;
            6)
                if confirm_action; then
                    restart_freebsd_nezha_agent
                fi
                ;;
            0)
                echo "$(get_text "exit_message")"
                break
                ;;
            *)
                echo "$(get_text "invalid_option")"
                ;;
        esac
        echo
    done
}

# Main script
select_language
detect_os

if [[ "$OS" == "Unsupported" || "$OS" == "Unknown" ]]; then
    echo "$(get_text "unsupported_os")"
    exit 1
fi

if [[ "$OS" == "FreeBSD" ]]; then
    display_freebsd_menu
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if is_vps_in_china; then
        display_menu 1
    else
        display_menu 0
    fi
else
    echo "$(get_text "unknown_os")"
fi
