#!/bin/bash

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
        echo "Nginx is already installed."
    else
        case "$OS" in
            ubuntu|debian)
                echo "Installing Nginx on $OS..."
                sudo apt update
                sudo apt install -y nginx
                ;;
            centos|redhat)
                echo "Installing Nginx on $OS..."
                sudo yum install -y epel-release
                sudo yum install -y nginx
                ;;
            *)
                echo "Nginx installation not supported for $OS"
                ;;
        esac
    fi
}

# Function to uninstall Nginx
uninstall_nginx() {
    if is_nginx_installed; then
        case "$OS" in
            ubuntu|debian)
                echo "Uninstalling Nginx on $OS..."
                sudo systemctl stop nginx
                sudo systemctl disable nginx
                sudo apt remove -y nginx nginx-common nginx-core
                sudo apt purge -y nginx nginx-common nginx-core
                sudo rm -rf /etc/nginx /usr/sbin/nginx /var/lib/nginx /var/log/nginx /var/www/html
                ;;
            centos|redhat)
                echo "Uninstalling Nginx on $OS..."
                sudo systemctl stop nginx
                sudo systemctl disable nginx
                sudo yum remove -y nginx
                sudo rm -rf /etc/nginx /usr/sbin/nginx /var/lib/nginx /var/log/nginx /var/www/html
                ;;
            *)
                echo "Nginx uninstallation not supported for $OS"
                ;;
        esac
    else
        echo "Nginx is not installed."
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
        echo "Nginx is not installed."
    fi
}

# Function to check if Docker is installed
is_docker_installed() {
    command -v docker >/dev/null 2>&1
}

# Function to install Docker
install_docker() {
    if is_docker_installed; then
        echo "Docker is already installed."
    else
        case "$OS" in
            ubuntu|debian)
                echo "Installing Docker on $OS..."
                sudo apt update
                sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$OS $(lsb_release -cs) stable"
                sudo apt update
                sudo apt install -y docker-ce
                ;;
            centos|redhat)
                echo "Installing Docker on $OS..."
                sudo yum install -y yum-utils
                sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                sudo yum install -y docker-ce docker-ce-cli containerd.io
                ;;
            *)
                echo "Docker installation not supported for $OS"
                ;;
        esac
    fi
}

# Function to uninstall Docker
uninstall_docker() {
    if is_docker_installed; then
        case "$OS" in
            ubuntu|debian)
                echo "Uninstalling Docker on $OS..."
                sudo systemctl stop docker
                sudo systemctl disable docker
                sudo apt remove -y docker-ce
                sudo apt purge -y docker-ce
                sudo rm -rf /var/lib/docker /etc/docker /var/run/docker.sock /usr/bin/docker
                ;;
            centos|redhat)
                echo "Uninstalling Docker on $OS..."
                sudo systemctl stop docker
                sudo systemctl disable docker
                sudo yum remove -y docker-ce docker-ce-cli containerd.io
                sudo rm -rf /var/lib/docker /etc/docker /var/run/docker.sock /usr/bin/docker
                ;;
            *)
                echo "Docker uninstallation not supported for $OS"
                ;;
        esac
    else
        echo "Docker is not installed."
    fi
}

# Function to check Docker installation info
info_docker() {
    if is_docker_installed; then
        echo "Docker is installed."
        echo "Docker binary location: $(command -v docker)"
        echo "Docker root directory: $(docker info --format '{{ .DockerRootDir }}')"
    else
        echo "Docker is not installed."
    fi
}

# Function to get user confirmation
confirm_action() {
    read -p "Are you sure you want to proceed? (y/n): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        return 0
    else
        echo "Action cancelled."
        return 1
    fi
}

# Function to set mirrors for China
set_mirrors() {
    case "$OS" in
        ubuntu|debian)
            echo "Setting mirrors for $OS..."
            sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|http://mirrors.aliyun.com/ubuntu/|g' /etc/apt/sources.list
            sudo apt update
            ;;
        centos|redhat)
            echo "Setting mirrors for $OS..."
            sudo sed -i 's|mirror.centos.org|mirrors.aliyun.com|g' /etc/yum.repos.d/CentOS-Base.repo
            sudo yum clean all
            sudo yum makecache
            ;;
        *)
            echo "Setting mirrors not supported for $OS"
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
        echo "Detected that the VPS is in China."
    else
        echo "Detected that the VPS is not in China."
    fi

    while true; do
        echo "Please choose an option:"
        echo "1) Install Nginx"
        echo "2) Install Docker"
        echo "3) Uninstall Nginx"
        echo "4) Uninstall Docker"
        echo "5) Check Nginx installation info"
        echo "6) Check Docker installation info"
        if [[ $is_china == 1 ]]; then
            echo "7) Set mirrors for China"
            echo "0) Exit"
            read -p "Choose an option [0-7]: " choice
        else
            echo "0) Exit"
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
                    echo "Invalid option."
                fi
                ;;
            0)
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option."
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
            echo "Nezha agent is already running."
						print_nezha_agent_pids
            return
        fi

        echo "Starting Nezha agent..."
        nohup ~/nezha/agent.sh > /dev/null 2>&1 &

        # Try to start the agent up to 5 times
        for i in {1..5}; do
            sleep 2
            if is_freebsd_nezha_agent_running; then
                echo "Nezha agent started successfully."
								print_nezha_agent_pids
                return
            else
                echo "Attempt $i failed, retrying..."
                nohup ~/nezha/agent.sh > /dev/null 2>&1 &
            fi
        done

        echo "Failed to start Nezha agent after 5 attempts."
    else
        echo "Nezha agent is not installed."
    fi
}

# Function to stop Nezha agent on FreeBSD
stop_freebsd_nezha_agent() {
		if is_freebsd_nezha_agent_installed; then
			if is_freebsd_nezha_agent_running; then
					echo "Stopping Nezha agent..."
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
            echo "Nezha agent installation completed and connected to dashboard at $domain:$port."
            print_nezha_agent_pids
            echo "Check the log file at ~/nezha/agent.log for more details."
            return
        else
            echo "Attempt $i failed, retrying..."
            nohup ./agent.sh > /dev/null 2>&1 &
        fi
    done

    echo "Failed to start Nezha agent after 5 attempts."
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
        echo "Uninstalling Nezha agent..."
        rm -rf ~/nezha ~/nezha_tmp
        echo "Nezha agent uninstallation completed."
    else
        echo "Nezha agent is not installed."
    fi
}

# Main script to handle FreeBSD menu
display_freebsd_menu() {
    echo "Detected FreeBSD system."
    while true; do
        echo "Please choose an option:"
        echo "1) Install Nezha agent"
        echo "2) Check Nezha agent status"
        echo "3) Uninstall Nezha agent"
        echo "4) Start Nezha agent"
        echo "5) Stop Nezha agent"
        echo "0) Exit"
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
                echo "Exiting."
                break
                ;;
            *)
                echo "Invalid option."
                ;;
        esac
        echo
    done
}

# Main script
detect_os

if [[ "$OS" == "Unsupported" || "$OS" == "Unknown" ]]; then
    echo "This script does not support your operating system."
    exit 1
fi

if [[ "$OS" == "FreeBSD" ]]; then
    display_freebsd_menu
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if is_vps_in_china; then
        display_linux_menu 1
    else
        display_linux_menu 0
    fi
else
    echo "This script is designed to run on Linux or FreeBSD systems."
fi
