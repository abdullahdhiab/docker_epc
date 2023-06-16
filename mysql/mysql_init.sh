#!/bin/bash


sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/# max_connections        = 151/max_connections        = 250/g" /etc/mysql/mysql.conf.d/mysqld.cnf
cat > ~/.my.cnf <<EOF
[mysql]
user=root
password=ims
EOF

usermod -d /var/lib/mysql/ mysql

echo 'Waiting for MySQL to start.'
/etc/init.d/mysql restart
while true; do
	echo 'quit' | mysql --connect-timeout=1 && break
done

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Grant privileges and set max connections
ROOT_USER_EXISTS=`mysql -u root -s -N -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE User = 'root' AND Host = '%')"`
if [[ "$ROOT_USER_EXISTS" == 0 ]]
then
	mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'ims'";
	mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION";
	mysql -u root -e "ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY ''"
	mysql -u root -e "FLUSH PRIVILEGES;"
fi

pkill -9 mysqld
sleep 5
mysqld_safe
