#!/bin/bash

function restart() {
	PARAM=$1
	
	echo "Restarting $PARAM ..."

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

	nohup java -jar ${RELEASE} >> /data/yxcg/log/$PARAM'.log' 2>&1 &
	
	echo "Restart $PARAM success!"

}

if [ ! -n "$1" ]; then 
	echo "restart error: params cannot be empty!"
elif [ "$1" == "all" ]; then
	restart 'common'
	restart 'goods'
	restart 'order'
	restart 'supplier'
	restart 'purchaser'
	restart 'pay'
	restart 'info'
	restart 'pay'
	restart 'search'
	restart 'platform'

	restart 'site'
	restart 'third'
	restart 'boss'
else 
	restart $1
fi


