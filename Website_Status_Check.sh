#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$SCRIPT_DIR/WebsiteTransferConfig.cfg"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi


# Set defaults if not configured

STATUS_CHECKS_ENABLED=${STATUS_CHECKS_ENABLED:-"nginx,ports,ip,ping,ssl,dns,firewall,disk"}

# Colors
LIGHT_BLUE='\e[93m'
RESET_COLOR='\e[0m'
PASS='\e[92m'
FAIL='\e[91m'

# Function to check if a check is enabled
is_check_enabled() {
    local check="$1"
    [[ ",$STATUS_CHECKS_ENABLED," == *",$check,"* ]]  # Changed from CHECKS_ENABLED to STATUS_CHECKS_ENABLED
}

# Script to perform website and server health checks

echo -e "${LIGHT_BLUE}==== Web Server Health Check ====${RESET_COLOR}"



# 1. Nginx status
if is_check_enabled "nginx"; then
    echo -e "${LIGHT_BLUE}>> Checking Nginx status...${RESET_COLOR}"
    if systemctl is-active --quiet nginx; then
        echo -e "${PASS}Nginx is running.${RESET_COLOR}"
    else
        echo -e "${FAIL}Nginx is NOT running!${RESET_COLOR}"
    fi
    systemctl status nginx --no-pager
    echo
fi

# 2. Open ports
if is_check_enabled "ports"; then
    echo -e "${LIGHT_BLUE}>> Checking open ports (80 and 443)...${RESET_COLOR}"
    if sudo netstat -tuln | grep -q ":80"; then
        echo -e "${PASS}Port 80 is open.${RESET_COLOR}"
    else
        echo -e "${FAIL}Port 80 is NOT open!${RESET_COLOR}"
    fi

    if sudo netstat -tuln | grep -q ":443"; then
        echo -e "${PASS}Port 443 is open.${RESET_COLOR}"
    else
        echo -e "${FAIL}Port 443 is NOT open!${RESET_COLOR}"
    fi
    echo
fi

# 3. Public IP vs Configured Domain IP
if is_check_enabled "ip"; then
    echo -e "${LIGHT_BLUE}>> Checking IP address comparison...${RESET_COLOR}"
    public_ip=$(curl -s http://ipinfo.io/ip)
    domain_ip=$(dig +short $DOMAIN)

    echo -e "${LIGHT_BLUE}Public IP: $public_ip${RESET_COLOR}"
    echo -e "${LIGHT_BLUE}Domain IP: $domain_ip${RESET_COLOR}"

    if [ "$public_ip" == "$domain_ip" ]; then
        echo -e "${PASS}Public IP matches the domain IP.${RESET_COLOR}"
    else
        echo -e "${FAIL}Public IP does NOT match the domain IP!${RESET_COLOR}"
    fi
    echo
fi

# 4. Ping domain
if is_check_enabled "ping"; then
    echo -e "${LIGHT_BLUE}>> Pinging domain ($DOMAIN)...${RESET_COLOR}"
    ping -c 3 $DOMAIN
    echo
fi

# 5. SSL Certificate Validity
if is_check_enabled "ssl"; then
    echo -e "${LIGHT_BLUE}>> Checking SSL certificate validity...${RESET_COLOR}"
    ssl_expiry=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates)
    echo -e "${PASS}$ssl_expiry${RESET_COLOR}"
    echo
fi

# 6. DNS Lookup
if is_check_enabled "dns"; then
    echo -e "${LIGHT_BLUE}>> Performing DNS lookup for $DOMAIN...${RESET_COLOR}"
    dig $DOMAIN
    echo
fi

# 7. Firewall Rules
if is_check_enabled "firewall"; then
    echo -e "${LIGHT_BLUE}>> Checking UFW status and rules...${RESET_COLOR}"
    if sudo ufw status | grep -q "Status: active"; then
        echo -e "${PASS}UFW is active. Rules:${RESET_COLOR}"
        sudo ufw status
    else
        echo -e "${FAIL}UFW is NOT active!${RESET_COLOR}"
    fi
    echo
fi

# 8. Disk Space
if is_check_enabled "disk"; then
    echo -e "${LIGHT_BLUE}>> Checking disk space...${RESET_COLOR}"
    df -h
    echo
fi

echo -e "${LIGHT_BLUE}==== Health Check Completed ====${RESET_COLOR}"