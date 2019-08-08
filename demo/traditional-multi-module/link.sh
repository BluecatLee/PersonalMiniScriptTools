#!/bin/bash

DATE=`date +%Y%m%d`

rm -rf /data/www/demo* && rm -rf /data/app/bin/server.jar && rm -rf /data/pay/bin/server.jar

echo "link site"
if [ ! -f "/data/www/demo-site" ];
then
	ln -s /data/sources/$DATE/demo-site /data/www/demo-site
fi

#link app
echo "link app"
if [ ! -f "/data/app/bin/server.jar" ];
then
        ln -s /data/sources/$DATE/demo-java-app/demo-platform-server-1.2.1-RELEASE.jar /data/app/bin/server.jar 
fi

echo "link pay"
#link pay
if [ ! -f "/data/pay/bin/server.jar"];
then 
        ln -s /data/sources/$DATE/demo-pay/pay-0.0.1-SNAPSHOT.jar /data/pay/bin/server.jar

fi

