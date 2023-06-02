#!/bin/bash
# Script is designed to provide output of computer information


# Searches for PC hostname 
# Provides hostname information
# Prints out available IP-addresses for host, not including 127 networks
# checks space in only root system, displayed as human-friendly text output
cat <<EOF
Current VM Information
======================
FQDN: $(hostname --fqdn)
Operating System and version: $(hostnamectl | head -n 7 | tail -n 1 | sed 's/Operating System: //')
IP Address: $(hostname -I)
Root Filesystem Space remaining:$(df -h -t ext4 --output=avail | tail -1) 
======================

EOF