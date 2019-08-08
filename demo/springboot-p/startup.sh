#!/bin/sh
JAVA_OPTS=""
CLASSPATH=""
CATALINA_OPTS=""
# $0 当前脚本的名称
PRG="$0"

RUN_USER="root"
PID_FILE="/data/app-api/tmp/tomcat.pid"

# ``用作命令替换，与$()一样，${}是变量替换
current_user=`whoami`
if [ "$current_user" != "$RUN_USER" ];then
  echo "please run $0 as user $RUN_USER" 1>&2
  exit 1
fi

# resolve links - $0 may be a softlink
# -h 是否是软链接 如果是软连接 循环找到文件真实路径
# ls 列出文件及目录 -l 以详细格式列表 -d 仅列出目录
# ls -ld "$PRG" 显示软连接真正的指向
# expr string : regex 执行模式匹配 
# 获取实际指向的文件路径
# 如果以/开头 说明是绝对路径 否则是相对路径 需要拼接上当前软连接所在目录
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
# 当前脚本所在目录
PRGDIR=`dirname "$PRG"`
# 上级目录即为当前应用的HOME目录
APP_HOME=`cd "$PRGDIR/.." >/dev/null; pwd`

# 日志文件路径
SPRINGBOOT_OUT="$APP_HOME"/logs/springboot.out

# set JAVA_OPTS 
# 从配置文件中获取jvm参数
ENV_CONF="$APP_HOME"/conf/env.conf
# -f 文件是否存在 
# sed 's/原字符串/新字符串/' file
# -i 直接修改文件 不输出到终端 g表示全局
# sed 's/"//g' filename 将制定文件中的所有"替换成空
# awk '/^[^#]/' 匹配不以#开头的每行
# tr "\n" ' ' 换行符换成空格
if [ -f $ENV_CONF ];then
   JAVA_OPTS=`sed 's/"//g' $ENV_CONF | awk '/^[^#]/' | tr "\n" ' '`
fi

# set CLASSPATH
# -d 是否是目录
# 将lib目录下的所有jar包添加到CLASSPATH变量
if [ -d "$APP_HOME"/lib ];then
  for lib_jar in `ls "$APP_HOME/lib"`;do
     CLASSPATH="$APP_HOME"/lib/"$lib_jar":"$CLASSPATH"
  done
fi

# User can set environment in setenv.sh
# -r 是否可读
# 扩展脚本 可设置其他环境变量
if [ -r "$APP_HOME/bin/setenv.sh" ]; then
  . "$APP_HOME/bin/setenv.sh"
fi

echo "Using JAVA_HOME:  $JAVA_HOME"
echo "Using APP_HOME:   $APP_HOME"
# -z 判断是否不为空
if [ ! -z "$CLASSPATH" ];then
  echo "Using CLASSPATH:  $CLASSPATH"
fi

if [ ! -z "$PID_FILE" ]; then
  echo "Using PID_FILE:   $PID_FILE"
fi

if [ ! -z "$PID_FILE" ]; then
  if [ -f "$PID_FILE" ]; then
    # -s 文件存在且大小不为0
    if [ -s "$PID_FILE" ]; then
      echo "Existing PID file found during start."
      if [ -r "$PID_FILE" ]; then
        PID=`cat "$PID_FILE"`
		# ps -p $PID 获取该进程的cpu运行时间 进程存在则命令返回0 否则返回1
		# 将标准输出重定向到/dev/null 将标准错误重定向到标准输出
        ps -p $PID >/dev/null 2>&1
		# $? 上一个命令的退出状态
        if [ $? -eq 0 ] ; then
          echo "Server appears to still be running with PID $PID. Start aborted."
          exit 0
        else
          echo "Removing/clearing stale PID file."
          rm -rf "$PID_FILE" >/dev/null 2>&1
          if [ $? != 0 ]; then
		    # -w 是否可写入 如果可写入 清空PID文件
            if [ -w "$PID_FILE" ]; then
              cat /dev/null > "$PID_FILE"
            else
              echo "Unable to remove or clear stale PID file. Start aborted."
              exit 1
            fi
          fi
        fi
      else
        echo "Unable to read PID file. Start aborted."
        exit 1
      fi
    else
      rm -rf "$PID_FILE" >/dev/null 2>&1
      if [ $? != 0 ]; then
        if [ ! -w "$PID_FILE" ]; then
          echo "Unable to remove or write to empty PID file. Start aborted."
          exit 1
        fi
      fi
    fi
  fi
fi

# Add server.jar to classpath, if CLASSPATH is not blank, it must be endswith ":"
CLASSPATH="$CLASSPATH""$APP_HOME"/bin/server.jar

#清空日志文件
cat /dev/null > ${SPRINGBOOT_OUT}

# java命令运行Spring boot项目时实际上是运行了JarLauncher类
java $JAVA_OPTS -classpath $CLASSPATH org.springframework.boot.loader.JarLauncher >> $SPRINGBOOT_OUT 2>&1 &
if [ ! -z "$PID_FILE" ]; then
  # $! 后台运行的最后一个进程的pid
  echo $! > "$PID_FILE"
fi

echo "springboot server started."
