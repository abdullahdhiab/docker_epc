
/etc/init.d/mysql start
/etc/init.d/rsyslog start
/etc/init.d/redis-server start

sed -i 's|OCS_IP|'$OCS_IP'|g' /etc/cgrates/diameter_agent.json
 
cd /usr/share/cgrates/storage/mysql/ && ./setup_cgr_db.sh root CGRateS.org localhost
cgr-migrator -exec "*set_versions" -config_path=/etc/cgrates/ -stordb_passwd=CGRateS.org

sleep 5
/cgrates_init.sh start
tail -f /var/log/cgrates/CGRateS.log
