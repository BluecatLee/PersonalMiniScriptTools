#/bin/sh

RUN_USER="root"
PID_FILE="/data/app-api/tmp/tomcat.pid"
SHUTDOWN_PORT="11000"

current_user=`whoami`
if [ "$current_user" != "$RUN_USER" ];then
  echo "please run $0 as user $RUN_USER"
  exit 1
fi

if [ ! -f "$PID_FILE" ];then
  echo "pid file $PID_FILE not exist, please check if server running, stop aborted."
  exit 1
fi

netstat -an | grep LISTEN | grep -w $SHUTDOWN_PORT
if [[ $? -eq 0 ]]; then
  shut_info=`curl --connect-timeout 10 -m 30 -XPOST http://127.0.0.1:"$SHUTDOWN_PORT"/shutdown.json`
  echo "shutdown info: $shut_info ,result code: $?"
fi

pid=`cat $PID_FILE`
for num in 1 2 3 4 5 6 7 8 9 10
do
  echo "stop times: $num"
  still_alive=`ps -ef | awk '$2 ~ /^'$pid'$/{print $2}'`
  if [ ! -z "$still_alive" ];then
    kill $pid
    sleep 1
  else
    break
  fi
done

still_alive=`ps -ef | awk '$2 ~ /^'$pid'$/{print $2}'`
if [ ! -z "$still_alive" ];then
  kill -9 $pid
fi

rm -rf $PID_FILE
exit 0
