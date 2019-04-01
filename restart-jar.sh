#!/bin/bash
# 获取某个启动命令中带有SNAPSHOT的java进程的PID
PID=`ps axu | grep java | grep SNAPSHOT | awk '{print $2}'`
# wc 统计(Word Count) -l表示统计行数
COUNT=`ps axu | grep java | grep SNAPSHOT | wc -l`
#查找指定目录下的文件 并匹配正则 将匹配成功的文件名赋值给变量
RELEASE=`find  /data/app -type f | egrep "app.*jar"`

echo $PID
echo $RELEASE

# -gt 表示大于
# && 与操作符 第一个命令执行成功才会执行第二个命令
# || 或操作符 第一个命令执行失败才会执行第二个命令
# nohup 不挂断的运行命令 退出账户后依然运行 (没有后台运行的含义)
#       无论是否将 nohup 命令的输出重定向到终端，输出都将附加到当前目录的 nohup.out 文件中
# & 表示在后台运行
# > 表示重定向到一个文件
# >> 表示追加到文件
# 2>&1 表示把标准错误重定向到标准输出
if [ $COUNT -gt 0 ];then
   echo "process is alive"! && kill -s 9 $PID && nohup java -jar ${RELEASE} >> app.log 2>&1 &
else
  nohup java -jar ${RELEASE} >> app.log 2>&1 &
fi
