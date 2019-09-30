#!/bin/bash

HOST=dev

RESTART_SCRIPT=/data/yxcg/scripts/restart.sh

function publish() {
	PARAM=$1
	
	if [[ "$PARAM" == "site" ]] || [[ "$PARAM" == "third" ]] || [[ "$PARAM" == "boss" ]]; then
       		PROJECT_NAME=yxcg-$PARAM
        	DEST_PATH=$PARAM
	elif [ "$PARAM" == "pay" ]; then
        	PROJECT_NAME=yegoo-pay-new
        	DEST_PATH=service
	else
        	PROJECT_NAME=yxcg-$PARAM-service
        	DEST_PATH=service
	fi

	#进入代码目录 获取最新代码
	PROJECT_PATH=/home/code/yxcg/$PROJECT_NAME
	cd $PROJECT_PATH && git checkout . && git pull

	#编译打包
	mvn clean install -DskipTests -f /home/code/yxcg/$PROJECT_NAME/pom.xml

	if [ $? -ne 0 ];
	then
	echo "error occured when publish $PARAM ,please reset"
	exit 0
	fi

	#除了common search模块 其余都是maven聚合工程 jar包在app模块下
	if [[ "$PARAM" == "common" ]] || [[ "$PARAM" == "search" ]]; then
        	SRC=$PROJECT_PATH/target/*.jar
	else
        	SRC=$PROJECT_PATH/app/target/*.jar
	fi
	DES=/data/yxcg/$DEST_PATH

	#传到远程服务器
	ssh root@$HOST "rm -rf $DES/$PROJECT_NAME'.jar'" && scp $SRC root@$HOST:$DES/$PROJECT_NAME".jar"

	#重启远程服务
    ssh root@$HOST "bash $RESTART_SCRIPT $PARAM"

}

#all
if [ ! -n "$1" ]; then
	echo "publish error: params cannot be empty!"
elif [ "$1" == "all" ]; then
	starttime=`date +'%Y-%m-%d %H:%M:%S'`

	publish 'common' &	
	publish 'goods' &
	publish 'supplier' & 
	publish 'purchaser' &
	publish 'info' &
    publish 'search' &
	publish 'order' & 
    publish 'platform' &
    publish 'pay' &

	wait

	publish 'site' &
	publish 'third' &
	publish 'boss' &
	
	wait

	endtime=`date +'%Y-%m-%d %H:%M:%S'`

	start_seconds=$(date --date="$starttime" +%s)
	end_seconds=$(date --date="$endtime" +%s)

	echo "==== Success publish all ===="
	echo "本次运行时间： "$((end_seconds-start_seconds))"s"
	
	#改造成并行打包并在打包完成就直接远程执行重启后 耗时减少了一半多

else 
	publish $1
fi
