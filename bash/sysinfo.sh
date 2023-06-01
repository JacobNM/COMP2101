#!/bin/bash
# Script is designed to provide output of computer information

# Searches for PC hostname ip address and prints it out, followed by new-line character
echo 'FQDN: $(hostname --f)'

# Provides hostname information
printf "Host Information:\n $(hostnamectl)\n"

# Prints out available IP-addresses for host, not including 127 networks
printf "IP Addresses:\n $(hostname -I)\n"

# checks space in only root system, displayed as human-friendly text output
printf "Root Filesystem Access:\n  $(df / -h)"

