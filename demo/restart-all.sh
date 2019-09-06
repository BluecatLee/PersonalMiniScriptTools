#!/bin/bash

#Start Rabbitmq
PID=$(netstat -tnlp | grep ':5672' | awk '{print $7}' | awk -F "/" '{print $1}')
if [ -n $PID ]; then
	echo "start rabbitmq."
	/usr/sbin/rabbitmq-server > /data/rabbitmq/rabbitmq.log 2>&1 &
fi

#Start Elasticsearch
PID=$(ps aux | grep elasticsearch | grep java | grep -v grep | awk '{print $2}')
if [ -n $PID ]; then
	echo "start es." 
        su - elasticsearch -c "/usr/local/elasticsearch/bin/elasticsearch" > /data/es/es.log 2>&1 &
fi

#Start Es-Head-Plugin
PID=$(netstat -tnlp | grep ':9100' | awk '{print $7}' | awk -F "/" '{print $1}')
if [ -n $PID ]; then 
	echo "start es-head."
	cd /usr/local/elasticsearch-head && nohup grunt server >> /data/es/es-head/eshead.log 2>&1 &
fi

#Start Consul
PID=$(ps aux | grep consul | grep -v grep | awk '{print $2}')
if [ -n $PID ]; then
	echo "start consul."
	nohup /usr/local/bin/consul agent -server -bootstrap-expect=1 -data-dir=/data/consul/data/node -client=0.0.0.0 -ui > /data/consul/consul.log &
fi

#Restart Micro-Services
echo "start services..."
sh /data/yxcg/scripts/restart.sh

