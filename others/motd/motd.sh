#!/bin/bash
NIC_NAME="eth0"

# colors
NC='\033[0m' # no color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'

# redirect stdout and stderr to /etc/motd
exec > /etc/motd 2>&1

# welcome message
source /etc/os-release
UNAME_INFO=$(uname -srmo)
printf "\nWelcome to %s (%s)\n\n" "$PRETTY_NAME" "$UNAME_INFO"

# logo
printf "${PURPLE}"
cat /home/fusion/.dotfiles/others/motd/icon
printf "${NC}This server is owned by 浮枕映画 Fusion Works Org.\n\n"

# get report date
REPORT_DATE=$(date)

# get cpu info
CPU_CORES=$(grep -c ^processor /proc/cpuinfo)
# get load average
read LOAD1 LOAD5 LOAD15 RUNNING_PROCESSES <<< $(awk '{print $1, $2, $3, $4}' /proc/loadavg)

# get logged-in sessions
LOGGED_IN_SESSION=$(who | wc -l)

# get local and public IP
LOCAL_IP=$(ip -4 addr show $NIC_NAME | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
PUBLIC_IP=$(curl -s https://api.ipify.org || echo "") && [ -z "$PUBLIC_IP" ] && PUBLIC_IP=$(curl -s cip.cc | grep -Eo 'IP\s*:\s*[0-9\.]+' | awk '{print $3}' || echo "UNKNOWN")

# get uptime
UP_TIME=$(uptime -p | sed 's/^up //')

# get memory info
memory_info=$(free)
memory_info_h=$(free -h)
mem_total_h=$(echo "$memory_info_h" | awk '/^Mem:/ {print $2}')
mem_used_h=$(echo "$memory_info_h" | awk '/^Mem:/ {print $3}')
mem_total_bytes=$(echo "$memory_info" | awk '/^Mem:/ {print $2}')
mem_used_bytes=$(echo "$memory_info" | awk '/^Mem:/ {print $3}')
mem_percent=$(if [ "$mem_total_bytes" -ne 0 ]; then echo "$((mem_used_bytes * 100 / mem_total_bytes))"; else echo "0"; fi)

swap_total_h=$(echo "$memory_info_h" | awk '/^Swap:/ {print $2}')
swap_used_h=$(echo "$memory_info_h" | awk '/^Swap:/ {print $3}')
swap_total_bytes=$(echo "$memory_info" | awk '/^Swap:/ {print $2}')
swap_used_bytes=$(echo "$memory_info" | awk '/^Swap:/ {print $3}')
swap_percent=$(if [ "$swap_total_bytes" -ne 0 ]; then echo "$((swap_used_bytes * 100 / swap_total_bytes))"; else echo "0"; fi)

# get disk info
disk_info=$(df -h / | awk '/\// {print $2, $3, $5}')
disk_total=$(echo "$disk_info" | awk '{print $1}')
disk_used=$(echo "$disk_info" | awk '{print $2}')
disk_percent=$(echo "$disk_info" | awk '{print $3}')

# get updates
UPDATES_COUNT=$(yum check-update --quiet | awk '/Obsoleting Packages/{flag=1;next}/^$/{flag=0}flag{next}1' | grep -v "^$" | wc -l)
SECURITY_UPDATES_COUNT=$(yum check-update --security --quiet | awk '/Obsoleting Packages/{flag=1;next}/^$/{flag=0}flag{next}1' | grep -v "^$" | wc -l)


choose_color() {
    local value=$1
    local type=$2
    case $type in
        "percent")
            if [ $value -lt 50 ]; then printf "$GREEN"
            elif [ $value -lt 75 ]; then printf "$YELLOW"
            else printf "$RED"
            fi
            ;;
        "load")
            local green_threshold=$(echo "$CPU_CORES * 0.7" | bc)
            local red_threshold=$CPU_CORES
            if (( $(echo "$value < $green_threshold" | bc -l) )); then
                printf "$GREEN"
            elif (( $(echo "$value >= $green_threshold && $value < $red_threshold" | bc -l) )); then
                printf "$YELLOW"
            else
                printf "$RED"
            fi
            ;;
        "update")
            [ $value -eq 0 ] && printf "$GREEN" || printf "$YELLOW"
            ;;
        "security")
            [ $value -eq 0 ] && printf "$GREEN" || printf "$RED"
            ;;
    esac
}

# print report
printf "%-25s: " "Report Date"
printf "${BLUE}%s${NC}\n\n" "$REPORT_DATE"

printf "%-25s: " "Uptime"
printf "${BLUE}%s${NC}\n" "$UP_TIME"
printf "%-25s: " "Logged-in Sessions"
printf "${BLUE}%s${NC}\n" "$LOGGED_IN_SESSION"
printf "%-25s: " "IPv4 address for $NIC_NAME"
printf "${BLUE}%s${NC} (Public: ${BLUE}%s${NC})\n\n" "$LOCAL_IP" "$PUBLIC_IP"

printf "%-25s: " "Load Avg (1/5/15 min)"
choose_color $LOAD1 "load" $CPU_CORES
printf "%s${NC} / " "$LOAD1"
choose_color $LOAD5 "load" $CPU_CORES
printf "%s${NC} / " "$LOAD5"
choose_color $LOAD15 "load" $CPU_CORES
printf "%s${NC}   |   Process running/all: ${BLUE}%s${NC}\n" "$LOAD15" "$RUNNING_PROCESSES"
printf "%-25s: " "RAM"
choose_color $mem_percent "percent"
printf "%s${NC} of ${BLUE}%s${NC} RAM used (" "$mem_used_h" "$mem_total_h"
choose_color $mem_percent "percent"
printf "%s%%${NC})\n" "$mem_percent"
printf "%-25s: " "Swap"
choose_color $swap_percent "percent"
printf "%s${NC} of ${BLUE}%s${NC} Swap used (" "$swap_used_h" "$swap_total_h"
choose_color $swap_percent "percent"
printf "%s%%${NC})\n" "$swap_percent"
printf "%-25s: " "Disk space (/)"
choose_color ${disk_percent%?} "percent"
printf "%s${NC} of ${BLUE}%s${NC} disk space used (" "$disk_used" "$disk_total"
choose_color ${disk_percent%?} "percent"
printf "%s${NC})\n\n" "$disk_percent"

printf "%-25s: All " "Updates"
choose_color $UPDATES_COUNT "update"
printf "%s${NC}  /  Security " "$UPDATES_COUNT"
choose_color $SECURITY_UPDATES_COUNT "security"
printf "%s${NC}\n" "$SECURITY_UPDATES_COUNT"

echo

