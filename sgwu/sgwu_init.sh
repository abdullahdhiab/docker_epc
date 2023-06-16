#!/bin/bash


export IF_NAME=$(ip r | awk '/default/ { print $5 }')

cp /mnt/sgwu/sgwu.yaml install/etc/open5gs
sed -i 's|SGWU_IP|'$SGWU_IP'|g' install/etc/open5gs/sgwu.yaml
sed -i 's|SGWC_IP|'$SGWC_IP'|g' install/etc/open5gs/sgwu.yaml
sed -i 's|SGWU_ADVERTISE_IP|'$SGWU_ADVERTISE_IP'|g' install/etc/open5gs/sgwu.yaml

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
