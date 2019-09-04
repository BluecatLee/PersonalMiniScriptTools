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
elif [ "$PARAM" == "site" ]; then
        PROJECT_NAME=yxcg-site-web
        REMOTE_DIR=/data/yxcg/site/static/
        cd /home/code/yxcg/$PROJECT_NAME && git checkout . && git pull
        sleep 2
        #tar -zcvf $PROJECT_NAME".tar.gz" ../$PROJECT_NAME/ --exclude *.tar.gz 
        #scp $PROJECT_NAME".tar.gz" root@$HOST:$REMOTE_DIR
        scp -r ./* root@$HOST:$REMOTE_DIR
elif [ "$PARAM" == "boss" ]; then
        PROJECT_NAME=yegoo-consumables-boss-web
        REMOTE_DIR=/data/yxcg/boss/static/
        publishVueProject $PROJECT_NAME $REMOTE_DIR
elif [ "$PARAM" == "third" ]; then
        PROJECT_NAME=yxcg-third-web
        REMOTE_DIR=/data/yxcg/third/static/
        publishVueProject $PROJECT_NAME $REMOTE_DIR
else
        echo "error params"
fi


