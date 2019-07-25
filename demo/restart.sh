#!/bin/bash

PARAM=$1

if [[ "$PARAM" == "site" ]] || [[ "$PARAM" == "third" ]] || [[ "$PARAM" == "boss" ]]; then
	RELEASE=/data/yxcg/$PARAM/yxcg-$PARAM'.jar'
elif [ "$PARAM" == "pay" ]; then
	RELEASE=/data/yxcg/service/yegoo-pay-new.jar
else
	RELEASE=/data/yxcg/service/yxcg-$PARAM-service.jar
fi

if [ "$PARAM" == "search" ]; then
	PID=`ps axu | grep $PARAM'-service' | grep java | awk '{print $2}'`
else 
	PID=`ps axu | grep $1 | grep java | awk '{print $2}'`
fi
echo $PID
kill -9 $PID

sleep 5

#RELEASE=`find  /data/marking -type f | egrep "app.*jar"`

nohup java -jar ${RELEASE} >> /data/yxcg/log/$PARAM'.log' 2>&1 &
