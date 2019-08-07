#!/bin/bash

PARAM=$1

HOST=medical-dev

function publishVueProject() {

	PROJECT_NAME=$1

	REMOTE_DIR=$2

	cd /home/code/yxcg/$PROJECT_NAME && git pull

	sleep 2

	npm install 

	node ./build/build.js 

	scp -r ./dist/* root@$HOST:$REMOTE_DIR

}


if [ ! -n "$1" ]; then
	echo "publish error: params cannot be empty!"
elif [ "$PARAM" == "third" ]; then
	echo "not supported now!"
elif [ "$PARAM" == "boss" ]; then 
	PROJECT_NAME=yegoo-consumables-boss-web
	REMOTE_DIR=/data/yxcg/boss/static/
	publishVueProject $PROJECT_NAME $REMOTE_DIR
else
	echo "error params"
fi

