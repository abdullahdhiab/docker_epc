#!/bin/bash


export DB_URI="mongodb://${MONGO_IP}/open5gs"

cd webui && npm run dev

# Sync docker time
#ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
