#!/bin/bash


export IF_NAME=$(ip r | awk '/default/ { print $5 }')

cp /mnt/sgwc/sgwc.yaml install/etc/open5gs
sed -i 's|SGWC_IP|'$SGWC_IP'|g' install/etc/open5gs/sgwc.yaml
sed -i 's|SGWU_IP|'$SGWU_IP'|g' install/etc/open5gs/sgwc.yaml

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
