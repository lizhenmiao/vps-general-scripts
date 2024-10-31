#!/bin/bash

# Declare associative arrays for English and Chinese translations
declare -A lang_en
declare -A lang_cn

# English translations
lang_en=(
    ["welcome"]="Detected FreeBSD system."
    ["choose_option"]="Please choose an option:"
    ["install_agent"]="Install Nezha agent"
    ["check_status"]="Check Nezha agent status"
    ["uninstall_agent"]="Uninstall Nezha agent"
    ["start_agent"]="Start Nezha agent"
    ["stop_agent"]="Stop Nezha agent"
    ["exit"]="Exit"
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
    ["docker_installed"]="Docker is already installed."
    ["installing_docker"]="Installing Docker on"
    ["uninstalling_docker"]="Uninstalling Docker on"
    ["docker_not_supported"]="Docker installation not supported for"
    ["docker_not_installed"]="Docker is not installed."
    ["set_mirrors"]="Setting mirrors for"
    ["mirrors_not_supported"]="Setting mirrors not supported for"
    ["vps_in_china"]="Detected that the VPS is in China."
    ["vps_not_in_china"]="Detected that the VPS is not in China."
)

# Chinese translations
lang_cn=(
    ["welcome"]="检测到 FreeBSD 系统。"
    ["choose_option"]="请选择一个选项："
    ["install_agent"]="安装哪吒探针"
    ["check_status"]="检查哪吒探针状态"
    ["uninstall_agent"]="卸载哪吒探针"
    ["start_agent"]="启动哪吒探针"
    ["stop_agent"]="停止哪吒探针"
    ["exit"]="退出"
    ["are_you_sure"]="你确定要继续吗？(y/n): "
    ["cancelled"]="操作取消。"
    ["invalid_option"]="无效选项。"
    ["already_running"]="哪吒探针已经在运行。"
    ["starting_agent"]="正在启动哪吒探针..."
    ["stopping_agent"]="正在停止哪吒探针..."
    ["uninstalling_agent"]="正在卸载哪吒探针..."
    ["installation_completed"]="哪吒探针安装完成并连接到面板"
    ["check_log"]="检查日志文件 ~/nezha/agent.log 以获取更多详细信息。"
    ["failed_start"]="启动哪吒探针失败，经过5次尝试。"
    ["nginx_installed"]="Nginx 已经安装。"
    ["installing_nginx"]="正在安装 Nginx 于"
    ["uninstalling_nginx"]="正在卸载 Nginx 于"
    ["nginx_not_supported"]="不支持在此系统上安装 Nginx"
    ["nginx_not_installed"]="Nginx 未安装。"
    ["docker_installed"]="Docker 已经安装。"
    ["installing_docker"]="正在安装 Docker 于"
    ["uninstalling_docker"]="正在卸载 Docker 于"
    ["docker_not_supported"]="不支持在此系统上安装 Docker"
    ["docker_not_installed"]="Docker 未安装。"
    ["set_mirrors"]="设置镜像源为"
    ["mirrors_not_supported"]="不支持在此系统上设置镜像源"
    ["vps_in_china"]="检测到 VPS 位于中国。"
    ["vps_not_in_china"]="检测到 VPS 不在中国。"
)

# Set default language
current_lang="en"

# Function to select language
select_language() {
    echo "Select language / 选择语言:"
    echo "1) English"
    echo "2) 中文"
    read -p "Choose an option [1-2]: " lang_choice
    case $lang_choice in
        1)
            current_lang="en"
            ;;
        2)
            current_lang="cn"
            ;;
        *)
            echo "Invalid option, defaulting to English."
            current_lang="en"
            ;;
    esac
}

# Function to get translated text
get_text() {
    local key=$1
    if [ "$current_lang" == "en" ]; then
        echo "${lang_en[$key]}"
    else
        echo "${lang_cn[$key]}"
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

        echo "IPv4 Address: $IPV4"
        echo "IPv6 Address: $IPV6"
        echo "MAC Address: $MAC"

    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        OS="FreeBSD"
        VERSION=$(uname -r)
    else
        OS="Unsupported"
        VERSION="Unknown"
    fi
    echo "Detected OS: $OS $VERSION"
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
        echo "Nginx is installed."
        echo "Nginx binary location: $(command -v nginx)"
        if [ -f /etc/nginx/nginx.conf ]; then
            echo "Nginx configuration file: /etc/nginx/nginx.conf"
        elif [ -f /usr/local/nginx/conf/nginx.conf ]; then
            echo "Nginx configuration file: /usr/local/nginx/conf/nginx.conf"
        else
            echo "Nginx configuration file location not found."
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
        echo "$(get_text "docker_installed")"
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
        echo "Docker is installed."
        echo "Docker binary location: $(command -v docker)"
        echo "Docker root directory: $(docker info --format '{{ .DockerRootDir }}')"
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
    local is_china=$1
    if [[ $is_china == 1 ]]; then
        echo "$(get_text "vps_in_china")"
    else
        echo "$(get_text "vps_not_in_china")"
    fi

    while true; do
        echo "$(get_text "choose_option")"
        echo "1) Install Nginx"
        echo "2) Install Docker"
        echo "3) Uninstall Nginx"
        echo "4) Uninstall Docker"
        echo "5) Check Nginx installation info"
        echo "6) Check Docker installation info"
        if [[ $is_china == 1 ]]; then
            echo "7) Set mirrors for China"
            echo "0) $(get_text "exit")"
            read -p "Choose an option [0-7]: " choice
        else
            echo "0) $(get_text "exit")"
            read -p "Choose an option [0-6]: " choice
        fi

        case $choice in
            1)
                if confirm_action; then
                    install_nginx
                fi
                ;;
            2)
                if confirm_action; then
                    install_docker
                fi
                ;;
            3)
                if confirm_action; then
                    uninstall_nginx
                fi
                ;;
            4)
                if confirm_action; then
                    uninstall_docker
                fi
                ;;
            5)
                info_nginx
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
                echo "$(get_text "exit")"
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
                echo "Attempt $i failed, retrying..."
                nohup ~/nezha/agent.sh > /dev/null 2>&1 &
            fi
        done

        echo "$(get_text "failed_start")"
    else
        echo "Nezha agent is not installed."
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
                echo "Terminated agent.sh with PID $agent_pid"
            fi
            if [ -n "$nezha_agent_pid" ]; then
                kill "$nezha_agent_pid"
                echo "Terminated nezha-agent with PID $nezha_agent_pid"
            fi
        else
            echo "Nezha agent is not running."
        fi
    else
        echo "Nezha agent is not installed."
    fi
}

# Function to install Nezha agent on FreeBSD
install_freebsd_nezha_agent() {
    if is_freebsd_nezha_agent_installed; then
        check_freebsd_nezha_agent_status
        return
    fi

    read -p "Enter the Nezha dashboard domain: " domain
    read -p "Enter the Nezha dashboard port: " port
    read -p "Enter the Nezha dashboard password: " password

    local latest_version=$(get_latest_nezha_version)
    if [ -z "$latest_version" ]; then
        echo "Failed to fetch the latest version of Nezha agent."
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
            echo "Attempt $i failed, retrying..."
            nohup ./agent.sh > /dev/null 2>&1 &
        fi
    done

    echo "$(get_text "failed_start")"
}

# Function to check the status of Nezha agent on FreeBSD
check_freebsd_nezha_agent_status() {
    if is_freebsd_nezha_agent_installed; then
        echo "Nezha agent is installed."
        if is_freebsd_nezha_agent_running; then
            echo "Nezha agent is currently running."
            print_nezha_agent_pids
        else
            echo "Nezha agent is installed but not running."
        fi
    else
        echo "Nezha agent is not installed."
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
        echo "Nezha agent uninstallation completed."
    else
        echo "Nezha agent is not installed."
    fi
}

# Main script to handle FreeBSD menu
display_freebsd_menu() {
    echo "$(get_text "welcome")"
    while true; do
        echo "$(get_text "choose_option")"
        echo "1) $(get_text "install_agent")"
        echo "2) $(get_text "check_status")"
        echo "3) $(get_text "uninstall_agent")"
        echo "4) $(get_text "start_agent")"
        echo "5) $(get_text "stop_agent")"
        echo "0) $(get_text "exit")"
        read -p "Choose an option [0-5]: " choice

        case $choice in
            1)
                if confirm_action; then
                    install_freebsd_nezha_agent
                fi
                ;;
            2)
                check_freebsd_nezha_agent_status
                ;;
            3)
                if confirm_action; then
                    uninstall_freebsd_nezha_agent
                fi
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
            0)
                echo "$(get_text "exit")"
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
    echo "This script does not support your operating system."
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
    echo "This script is designed to run on Linux or FreeBSD systems."
fi
