#!/bin/bash


export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)
export IF_NAME=$(ip r | awk '/default/ { print $5 }')

[ ${#MNC} == 3 ] && EPC_DOMAIN="epc.mnc${MNC}.mcc${MCC}.sgstel.com" || EPC_DOMAIN="epc.mnc0${MNC}.mcc${MCC}.sgstel.com"

cp /mnt/mme/mme.yaml install/etc/open5gs
cp /mnt/mme/mme.conf install/etc/freeDiameter
cp /mnt/mme/make_certs.sh install/etc/freeDiameter

sed -i 's|MNC|'$MNC'|g' install/etc/open5gs/mme.yaml
sed -i 's|MCC|'$MCC'|g' install/etc/open5gs/mme.yaml
sed -i 's|MME_IP|'$MME_IP'|g' install/etc/open5gs/mme.yaml
sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/open5gs/mme.yaml
sed -i 's|MME_IF|'$IF_NAME'|g' install/etc/open5gs/mme.yaml
#sed -i 's|OSMOMSC_IP|'$OSMOMSC_IP'|g' install/etc/open5gs/mme.yaml
sed -i 's|SGWC_IP|'$SGWC_IP'|g' install/etc/open5gs/mme.yaml
#sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/open5gs/mme.yaml
sed -i 's|MME_IP|'$MME_IP'|g' install/etc/freeDiameter/mme.conf
sed -i 's|HSS_IP|'$HSS_IP'|g' install/etc/freeDiameter/mme.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/mme.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/make_certs.sh

# Generate TLS certificates
./install/etc/freeDiameter/make_certs.sh install/etc/freeDiameter

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
