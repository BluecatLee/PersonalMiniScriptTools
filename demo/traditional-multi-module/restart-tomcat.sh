#!/bin/bash

# ps 查看进程 -a表示查看所有 -x表示没有控制终端的进程 -u表示查看特定用户的进程
# ps -ef是System V风格, ps aux 是FSD风格(aux会截断command列)
# | 管道命令 前一个命令的正确输出作为后一个命令的输入
# grep 全面搜索正则表达式 并把匹配的行打印出来 (只能使用基本正则表达式)
# egrep 相当于grep -E (可以使用扩展正则表达式)
# -v参数表示反向搜索
# 外部传入参数 多个搜索结果的时候用来匹配某一个进程
# awk [-Field-separator] 'commands' input-file(s)
# 按空格分隔 第二个参数为PID
PID=`ps axu | grep java | egrep -v grep | grep $1 | awk '{print $2}'`

echo $PID

echo "prepare to shutdown tomcat-${1}"

# kill -s 9 [pid] 相当于 kill -9 [pid] 
kill -s 9 $PID

# sleep 表示延迟一段时间后再执行后面命令 默认单位为s
sleep 10 && echo "check tomcat-${1} !"

# -n 判断字符串非空
if [ -n $PID ];then
   echo 'tomcat is down ,prepare to start'
else
   echo 'shutdown is failed, please to retry ' && sleep 5 && kill -9 $PID
fi

echo "start tomcat-${1} !"


if [ $1 = app ];then
   bash /home/app-api/bin/startup.sh

elif [ $1 = living-payment ];then
   bash /home/living-payment/bin/startup.sh

else
   bash /home/tomcat-"$1"/bin/startup.sh

fi