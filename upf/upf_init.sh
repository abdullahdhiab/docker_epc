#!/bin/bash


export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)
export IF_NAME=$(ip r | awk '/default/ { print $5 }')

python3 /mnt/upf/tun_if.py --tun_ifname ogstun --ipv4_range 192.168.100.0/24 --ipv6_range 2001:230:cafe::/48
python3 /mnt/upf/tun_if.py --tun_ifname ogstun2 --ipv4_range 192.168.101.0/24 --ipv6_range 2001:230:babe::/48 --nat_rule 'no'

cp /mnt/upf/upf.yaml install/etc/open5gs
sed -i 's|UPF_IP|'$UPF_IP'|g' install/etc/open5gs/upf.yaml
sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/open5gs/upf.yaml
sed -i 's|UPF_ADVERTISE_IP|'$UPF_ADVERTISE_IP'|g' install/etc/open5gs/upf.yaml

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
