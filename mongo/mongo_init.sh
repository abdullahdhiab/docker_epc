#!/bin/bash


# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

mongod --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongodb.log --bind_ip 0.0.0.0
