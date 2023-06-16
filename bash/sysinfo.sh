#!/bin/bash
# Script is designed to provide output of computer information

## Checks is user is root; if not, prompts them to use sudo for commands
# if [ "$(whoami)" != "root" ]; then echo "must be root (try "sudo" at beginning of script command)";exit 1; fi

# Grabs operating system release file for utilization of variables contained within
source /etc/os-release

## Variable list

# Inspection tools
lshwOutput=$(sudo lshw)
lscpuVariants=([1]="lscpu" [2]="lscpu --caches=NAME,ONE-SIZE")

# Basic Info variables
Current_Time=$(date +"%I:%M%p %Z")
MY_FQDN=$(hostname -f)
My_IP=$(hostname -I)
Root_FileSystem_Space=$(df -h -t ext4 --output=avail | tail -1 | sed 's/  *//') 

# System variables
Computer_Manufacturer=$(sudo dmidecode -s system-manufacturer)
Computer_Model=$(echo "$lshwOutput" | grep -w "product" | head -n 1 | sed 's/.*product: //')
Computer_Serial_Numer=$(echo "$lshwOutput" | grep -w "serial:" | head -n 1 | sed 's/ *serial: //')

# CPU variables
CPU_Manufacturer=$(echo "$lshwOutput" | grep -a2 cpu:0 | tail -n 1 | sed 's/.*product: //')
CPU_Architecture=$(hostnamectl | grep Architecture | sed 's/  *Architecture: //')
CPU_Max_Speed=$(echo "$lshwOutput" | grep capacity | head -n 1 | sed 's/.*capacity: //')
CPU_Total_Cores=$(( $(${lscpuVariants[1]} | awk '/^Socket\(s\)/{ print $2 }') * $(lscpu | awk '/^Core\(s\) per socket/{ print $4 }') ))
CPU_L1_Cache_Size=$(${lscpuVariants[2]} | grep L1 | sed 's/K/KB/' | sed '2 s/L1/                                 L1/')
CPU_L2_Cache_Size=$(${lscpuVariants[2]} | grep L2 | sed 's/K/KB/')
CPU_L3_Cache_Size=$(${lscpuVariants[2]} | grep L3 | sed 's/M/MB/' )


# Script will Search for PC hostname, print available IP addresses of host (not including 127 networks)
# checks available space in root system, displayed as human-friendly text output
# Provided in template form using cat command

cat <<EOF

System info produced by $USER at $Current_Time

Current VM Information
======================
FQDN:                            $MY_FQDN
IP Address:                      $My_IP
Root Filesystem Space Remaining: $Root_FileSystem_Space
======================

System Description
==================
Manufacturer/Vendor:             $Computer_Manufacturer
Computer Description:            $Computer_Model
Computer Serial Number:          $Computer_Serial_Numer
==================

CPU Information
===============
CPU Manufacturer/Model:          $CPU_Manufacturer
CPU Architecture:                $CPU_Architecture
CPU Core Total:                  $CPU_Total_Cores
CPU Max Speed:                   $CPU_Max_Speed
CPU L1 Cache Size:               $CPU_L1_Cache_Size
CPU L2 Cache Size:               $CPU_L2_Cache_Size
CPU L3 Cache Size:               $CPU_L3_Cache_Size
===============

Operating System Information
============================
Operating System:                $NAME
Version:                         $VERSION
============================

Ram Information
===============


===============

Disk Storage Information
========================


========================


EOF