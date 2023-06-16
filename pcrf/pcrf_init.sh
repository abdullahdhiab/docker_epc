#!/bin/bash


export IP_ADDR=$(awk 'END{print $1}' /etc/hosts)
export DB_URI="mongodb://${MONGO_IP}/open5gs"

[ ${#MNC} == 3 ] && EPC_DOMAIN="epc.mnc${MNC}.mcc${MCC}.sgstel.com" || EPC_DOMAIN="epc.mnc0${MNC}.mcc${MCC}.sgstel.com"
[ ${#MNC} == 3 ] && IMS_DOMAIN="ims.mnc${MNC}.mcc${MCC}.sgstel.com" || IMS_DOMAIN="ims.mnc0${MNC}.mcc${MCC}.sgstel.com"

cp /mnt/pcrf/pcrf.yaml install/etc/open5gs
cp /mnt/pcrf/pcrf.conf install/etc/freeDiameter
cp /mnt/pcrf/make_certs.sh install/etc/freeDiameter

sed -i 's|MONGO_IP|'$MONGO_IP'|g' install/etc/open5gs/pcrf.yaml
sed -i 's|PCRF_IP|'$PCRF_IP'|g' install/etc/freeDiameter/pcrf.conf
sed -i 's|SMF_IP|'$SMF_IP'|g' install/etc/freeDiameter/pcrf.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/pcrf.conf
sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' install/etc/freeDiameter/pcrf.conf
# sed -i 's|PCSCF_IP|'$PCSCF_IP'|g' install/etc/freeDiameter/pcrf.conf
sed -i 's|EPC_DOMAIN|'$EPC_DOMAIN'|g' install/etc/freeDiameter/make_certs.sh

# Generate TLS certificates
./install/etc/freeDiameter/make_certs.sh install/etc/freeDiameter

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
