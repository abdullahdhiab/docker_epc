#!/bin/bash


# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

mkdir -p /config

cp /mnt/metrics/prometheus.yml /config/

sed -i 's|AMF_IP|'$AMF_IP'|g' /config/prometheus.yml
sed -i 's|SMF_IP|'$SMF_IP'|g' /config/prometheus.yml
sed -i 's|MME_IP|'$MME_IP'|g' /config/prometheus.yml
sed -i 's|PCF_IP|'$PCF_IP'|g' /config/prometheus.yml
sed -i 's|UPF_IP|'$UPF_IP'|g' /config/prometheus.yml

./prometheus --config.file=/config/prometheus.yml
