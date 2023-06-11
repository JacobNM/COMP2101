#!/bin/bash
# Script is designed to provide output of computer information

## Checks is user is root; if not, prompts them to use sudo for commands
# if [ "$(whoami)" != "root" ]; then echo "must be root (try sudo at beginning of command)";exit 1; fi

# Grabs operating system release file for utilization of variables contained within
source /etc/os-release

## Variable list
# System variables
My_Computer_Vendor=$(sudo lshw | grep -w "vendor" | head -n 1 | sed 's/ *vendor: //')
Computer_Serial_Numer=$(sudo lshw | grep -w "serial:" | head -n 1 | sed 's/ *serial: //')

# CPU variables
CPU_Manufacturer=$(sudo dmidecode -s processor-manufacturer | head -n 1)
CPU_Architecture=$(hostnamectl | grep Architecture | sed 's/  *Architecture: //')
CPU_Max_Speed=$(sudo dmidecode -t processor | grep Hz | head -n 1 | sed 's/ *Max Speed://')
# Operating System variables
MY_FQDN=$(hostname -f)
My_IP=$(hostname -I)
Root_FileSystem_Space=$(df -h -t ext4 --output=avail | tail -1 | sed 's/  *//') 
#CPU_manufacturer=$(sudo lshw | grep -w -A 12 "cpu:0")  << NOT FINISHED

# Searches for PC hostname 
# Provides hostname information
# Prints out available IP-addresses for host, not including 127 networks
# checks available space in only root system, displayed as human-friendly text output
# Provided in template form using cat

cat <<EOF

System info produced by $USER


System Description
==================
Manufacturer/Vendor:             $My_Computer_Vendor
Operating System And Version:    $PRETTY_NAME
Computer Serial Number:          $Computer_Serial_Numer
==================

CPU Information
===============
CPU Manufacturer/Model:          $CPU_Manufacturer
CPU Architecture:                $CPU_Architecture
CPU Max Speed:                 $CPU_Max_Speed

Current VM Information
======================
FQDN:                            $MY_FQDN
IP Address:                      $My_IP
Root Filesystem Space Remaining: $Root_FileSystem_Space
======================

EOF