#!/bin/bash
# Script is designed to provide output of computer information

## Checks is user is root; if not, prompts them to use sudo for commands
# if [ "$(whoami)" != "root" ]; then echo "must be root (try sudo at beginning of command)";exit 1; fi


source /etc/os-release

# Variable list
MYFQDN=$(hostname -f)
Operating_System_And_Version=$(hostnamectl | grep -w "Operating System" | sed 's/Operating System:/Operating System and version:/')
My_IP=$(hostname -I)
Root_FileSystem_Space=$(df -h -t ext4 --output=avail | tail -1) 
My_Computer_Vendor=$(sudo lshw | grep -w "vendor" | head -n 1 | sed 's/    vendor: //')

# Searches for PC hostname 
# Provides hostname information
# Prints out available IP-addresses for host, not including 127 networks
# checks available space in only root system, displayed as human-friendly text output
# Provided in template form using cat

cat <<EOF

System info produced by $USER


System Description
==================
Vendor: $My_Computer_Vendor


Current VM Information
======================
FQDN: $MYFQDN
$Operating_System_And_Version
IP Address:$My_IP 
Root Filesystem Space remaining:$Root_FileSystem_Space
======================

EOF