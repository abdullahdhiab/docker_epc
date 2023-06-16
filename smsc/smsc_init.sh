#!/bin/bash


[ ${#MNC} == 3 ] && IMS_DOMAIN="ims.mnc${MNC}.mcc${MCC}.sgstel.com" || IMS_DOMAIN="ims.mnc0${MNC}.mcc${MCC}.sgstel.com"

mkdir -p /etc/kamailio_smsc
cp /mnt/smsc/smsc.cfg /etc/kamailio_smsc
cp /mnt/smsc/kamailio_smsc.cfg /etc/kamailio_smsc

while ! mysqladmin ping -h ${MYSQL_IP} --silent; do
	sleep 5;
done

# Sleep until permissions are set
sleep 10;

# Create SMSC database, populate tables and grant privileges
if [[ -z "`mysql -u root -h ${MYSQL_IP} -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='smsc'" 2>&1`" ]];
then
	mysql -u root -h ${MYSQL_IP} -e "create database smsc;"
	mysql -u root -h ${MYSQL_IP} smsc < /usr/local/src/kamailio/utils/kamctl/mysql/standard-create.sql
	mysql -u root -h ${MYSQL_IP} smsc < /mnt/smsc/smsc-create.sql
	mysql -u root -h ${MYSQL_IP} smsc < /usr/local/src/kamailio/utils/kamctl/mysql/dialplan-create.sql
	mysql -u root -h ${MYSQL_IP} smsc < /usr/local/src/kamailio/utils/kamctl/mysql/presence-create.sql

	SMSC_USER_EXISTS=`mysql -u root -h ${MYSQL_IP} -s -N -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE User = 'smsc' AND Host = '%')"`
	if [[ "$SMSC_USER_EXISTS" == 0 ]]
	then
		mysql -u root -h ${MYSQL_IP} -e "CREATE USER 'smsc'@'%' IDENTIFIED WITH mysql_native_password BY 'heslo'";
		mysql -u root -h ${MYSQL_IP} -e "CREATE USER 'smsc'@'$SMSC_IP' IDENTIFIED WITH mysql_native_password BY 'heslo'";
		mysql -u root -h ${MYSQL_IP} -e "GRANT ALL ON smsc.* TO 'smsc'@'%'";
		mysql -u root -h ${MYSQL_IP} -e "GRANT ALL ON smsc.* TO 'smsc'@'$SMSC_IP'";
		mysql -u root -h ${MYSQL_IP} -e "FLUSH PRIVILEGES;"
	fi
fi

sed -i 's|SMSC_IP|'$SMSC_IP'|g' /etc/kamailio_smsc/smsc.cfg
sed -i 's|IMS_DOMAIN|'$IMS_DOMAIN'|g' /etc/kamailio_smsc/smsc.cfg
sed -i 's|MYSQL_IP|'$MYSQL_IP'|g' /etc/kamailio_smsc/smsc.cfg

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
