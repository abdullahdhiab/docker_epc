#!/bin/bash


export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)
export IF_NAME=$(ip r | awk '/default/ { print $5 }')

[ ${#MNC} == 3 ] && EPC_DOMAIN="epc.mnc${MNC}.mcc${MCC}.sgstel.com" || EPC_DOMAIN="epc.mnc0${MNC}.mcc${MCC}.sgstel.com"

cp /mnt/smf/smf.yaml install/etc/open5gs
cp /mnt/smf/smf.conf install/etc/freeDiameter
cp /mnt/smf/make_certs.sh install/etc/freeDiameter

sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/open5gs/smf.yaml
# sed -i 's|SCP_IP|'$SCP_IP'|g' install/etc/open5gs/smf.yaml
sed -i 's|UPF_IP|'$UPF_IP'|g' install/etc/open5gs/smf.yaml
# sed -i 's|PCSCF_IP|'$PCSCF_IP'|g' install/etc/open5gs/smf.yaml
sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/freeDiameter/smf.conf
sed -i 's|PCRF_IP|'$PCRF_IP'|g' install/etc/freeDiameter/smf.conf
sed -i 's|OCS_IP|'$OCS_IP'|g' install/etc/freeDiameter/smf.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/smf.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/make_certs.sh

# Generate TLS certificates
./install/etc/freeDiameter/make_certs.sh install/etc/freeDiameter

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
