#!/bin/bash

# Script is designed to provide output of computer information in human-readable formatting

## Checks is user is root; if not, prompts them to use sudo for commands
if [ "$(whoami)" != "root" ]; then echo "must be root (try 'sudo' at beginning of script command)";exit 1; fi

# Grabs operating system release file and function list script for utilization of variables contained within
# Script is designed to provide output of computer information in human-readable formatting
source /etc/os-release
source reportfunctions.sh

# Inspection tools
LshwOutput=$(lshw)
DmidecodeOutput=$(dmidecode -t 17)
# Tools are set up as arrays to be used for separate variables below
LscpuVariants=([1]="lscpu" [2]="lscpu --caches=NAME,ONE-SIZE")
LsblkOutput=$(lsblk -l)
    # Inspection tools used for variables created in sections below


# default option values
verbose=false
System_Report=false
Disk_Report=false
Network_Report=false

# loop created to filter for extra commands on command line
while [ $# -gt 0 ]; do
    case ${1} in
        -h)
        displayhelp
        exit 0
        ;;
        -v)
        verbose=true
        ;;
        -system)
        System_Report=true
        ;;
        -disk)
        Disk_Report=true
        ;;
        -network)
        Network_Report=true
        ;;
        *)
        echo "Oops. Your command is not a valid one. Refer to the help section below"
        error-message "$@"
        displayhelp
        exit 1
        ;;
    esac
    shift
done

# Check to see which reports have been requested on command line;
# If no additional arguments selected, run full report
if [[ $verbose == true ]]; then
   error-message 
elif [[ "$System_Report" == true ]]; then
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
elif [[ "$Disk_Report" == true ]]; then
    diskreport
elif [[ "$Network_Report" == true ]]; then
    networkreport
else
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
    diskreport
    networkreport
fi