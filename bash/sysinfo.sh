#!/bin/bash
# Script is designed to provide output of computer information in human-readable formatting

## Checks is user is root; if not, prompts them to use sudo for commands
# if [ "$(whoami)" != "root" ]; then echo "must be root (try "sudo" at beginning of script command)";exit 1; fi

# Grabs operating system release file for utilization of variables contained within
source /etc/os-release

## Variable lists

# Inspection tools
LshwOutput=$(sudo lshw)
DmidecodeOutput=$(sudo dmidecode -t 17)
# Tool is set up as an array to be used for separate variables below
LscpuVariants=([1]="lscpu" [2]="lscpu --caches=NAME,ONE-SIZE")
    # Inspection tools used for variables created in sections below

# Provides current time and timezone
Current_Time=$(date +"%I:%M%p %Z")
# Searches for PC hostname 
MY_FQDN=$(hostname -f)
# Prints IP address of host (not including 127 networks)
My_IP=$(hostname -I)
# Checks root system for remaining available space
Root_FileSystem_Space=$(df -h -t ext4 --output=avail | tail -1 | sed 's/  *//') 

# System variables - Used to obtain personal computer information
Computer_Manufacturer=$(sudo dmidecode -s system-manufacturer)
Computer_Model=$(echo "$LshwOutput" | grep -m1 -w "product" | sed 's/.*product: //')
Computer_Serial_Numer=$(echo "$LshwOutput" | grep -m1 -w "serial:" | sed 's/ *serial: //')

# CPU variables - Used to obtain information on CPU from personal computer
CPU_Manufacturer=$(echo "$LshwOutput" | grep -a2 cpu:0 | tail -n 1 | sed 's/.*product: //')
CPU_Architecture=$(hostnamectl | grep Architecture | sed 's/  *Architecture: //')
CPU_Max_Speed=$(echo "$LshwOutput" | grep -m1 capacity | sed 's/.*capacity: //')
CPU_Total_Cores=$(( $(${LscpuVariants[1]} | awk '/^Socket\(s\)/{ print $2 }') * $(lscpu | awk '/^Core\(s\) per socket/{ print $4 }') ))
CPU_L1_Cache_Size=$(${LscpuVariants[2]} | grep L1 | sed 's/K/KB/' | sed '2 s/L1/                                 L1/')
CPU_L2_Cache_Size=$(${LscpuVariants[2]} | grep L2 | sed 's/K/KB/')
CPU_L3_Cache_Size=$(${LscpuVariants[2]} | grep L3 | sed 's/M/MB/' )

# RAM/DIMM variables - Used to obtain information on installed memory components
    # If specific information is not indicated in certain variables,
        ## user is informed that output is N/A when using VMs
DIMM_Manufacturer=$(echo "$DmidecodeOutput" | grep -m1 -i manufacturer | sed 's/.*Manufacturer: //')
if [[ "${DIMM_Manufacturer}" == "Not Specified" ]]; then
    DIMM_Manufacturer="N/A with VMs"
fi

DIMM_Model=$(echo "$DmidecodeOutput" | grep -m1 -w "Serial Number" | sed 's/.*Serial Number: //')
if [[ "${DIMM_Model}" == "Not Specified" ]]; then
    DIMM_Model="N/A with VMs"
fi

DIMM_Size=$(echo "$LshwOutput" | grep -i -A9 "\*\-memory" | tail -n1 | sed 's/.*size: //')

DIMM_Speed=$(echo "$DmidecodeOutput" | grep -m1 Speed | sed 's/.*Speed: //')
if [[ "${DIMM_Speed}" == "Unknown" ]]; then
   DIMM_Speed="N/A with VMs"
fi

DIMM_Location=$(echo "$LshwOutput" | grep -m1 'slot: RAM' | sed 's/.*slot: //')
    
    # Displays total RAM available to determine if all memory components are accounted for
RAM_Total_Size=$(echo "$LshwOutput" | grep -A10 '\*\-memory' | grep -m1 size | sed 's/.*size: // ')

    # Creates a structured table to display DIMM variables & RAM total memory included above
DIMM_Table=$(paste -d ';' <(echo "$DIMM_Manufacturer") <(
    echo "$DIMM_Model") <(echo "$DIMM_Size") <(echo "$DIMM_Speed") <(
    echo "$DIMM_Location") <(echo "$RAM_Total_Size") |
    column -N Manufacturer,Model,Size,Speed,Location,'Total RAM' -s ';' -o ' | ' -t)

# Disk Storage Variables

Drive_Manufacturer=$(echo "$LshwOutput" | grep -A10 "\*\-disk" | grep vendor | sed 's/.*vendor: //')
Drive_Model=$(echo "$LshwOutput" | grep -A10 "\*\-disk" | grep 'product' | sed 's/.*product: //' )
Drive_Size=$(lsblk | grep -m1 sda | awk '{print $4}' | sed 's/$/B/')

    # Creates a structured table to display Disk variables included above
Drive_Table=$(paste -d ';' <(echo "$Drive_Manufacturer ") <(echo "$Drive_Model") <(
    echo "$Drive_Size") | 
    column -N Manufacturer,Model,Size -s ';' -o ' | ' -t)

# Information extracted is provided in human-readable format using cat command
    # Tables are created to house relevant variables from above
    # DIMM Table and Disk Storage tables are pre-made in corresponding variable sections above

cat <<EOF

System info produced by $USER at $Current_Time

Current VM Information
======================
FQDN:                            $MY_FQDN
IP Address:                      $My_IP
Root Filesystem Space Remaining: $Root_FileSystem_Space
======================

System Information
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

RAM Information
==========================================================================
                            Installed DIMMs
$DIMM_Table

==========================================================================

Disk Storage Information
========================
                            Installed Drives
$Drive_Table

========================

EOF
     