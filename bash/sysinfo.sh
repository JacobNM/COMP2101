#!/bin/bash
# Script is designed to provide output of computer information


# Searches for PC hostname 
# Provides hostname information
# Prints out available IP-addresses for host, not including 127 networks
# checks available space in only root system, displayed as human-friendly text output
cat <<EOF
Current VM Information
======================
FQDN: $(hostname --fqdn)
$(hostnamectl | grep -w "Operating System" | sed 's/Operating System:/Operating System and version:/')
IP Address: $(hostname -I)
Root Filesystem Space remaining:$(df -h -t ext4 --output=avail | tail -1) 
======================

EOF