#!/bin/bash

# 使环境变量生效
# 在当前bash环境中执行/etc/profile中的命令 可以无执行权限
# 与./etc/profile等效 source是bash shell的内置命令 .是Bourne Shell的命令
source /etc/profile

echo 'demo deploy script'

echo 'compile...'

# bash 使用bash执行脚本
bash /data/scripts/.git-pull.sh

# $? 表示上个命令的退出状态或者函数的返回值
# -ne 表示不等于
if [ $? -ne 0 ]
then
        echo 'pull error.'
        return -1
fi

# 编译安装组件并跳过测试 
# -pl (--project)   执行项目名(模块名)
# -am (--also-make) 同时处理指定模块所依赖的模块
mvn clean install -DskipTests -f /data/code/demo-java/pom.xml -pl demo_site -am


if [ $? -ne 0 ]
then
        echo 'compile error.'
        return -1
fi

# 设置变量SRC_DIR 表示编译后的代码的路径
SRC_DIR=/data/code/demo-java/demo_site/target/demo-site/
# 设置变量DES_DIR 表示编译后的代码的输出路径
DES_DIR=/data/www/demo-site/
# 设置变量HOST
HOST=uat

# rsync [OPTION...] [USER@]HOST:SRC... [DEST] 本地文件同步到远程
# -a --archive  ：归档模式，表示递归传输并保持文件属性
# -v            ：显示rsync过程中详细信息
# -z            ：传输时进行压缩提高效率
# -e            ：指定所要使用的远程shell程序，默认为ssh
# --progress    ：显示进度信息
# --delete      ：以SRC为主，对DEST进行同步。多则删之，少则补之。注意"--delete"是在接收端执行的，所以它是在exclude/include规则生效之后才执行的# 
# --exclude     ：指定排除规则来排除不需要传输的文件

# scp [参数] [原路径] [目标路径]  远程拷贝命令

# 此处表示将本地/data/code/demo-java/demo_site/target/demo-site/下的文件传输到root@uat服务器上的/data/www/demo-site/目录下 
# 并将当前目录下的wechat.properties使用安全的远程拷贝方式传输到uat机器的指定目录中
rsync -avze ssh --progress --delete $SRC_DIR root@$HOST:$DES_DIR --exclude "*servlet-api*.jar" && scp .wechat.properties root@$HOST:$DES_DIR/WEB-INF/classes/wechat.properties