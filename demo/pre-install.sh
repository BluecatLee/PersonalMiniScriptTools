#!/bin/bash
# 一个安装脚本 
# 用于项目批量部署在多个机器上
# 预安装一些通用的软件(如jdk mysql)并保证版本一致和配置一致

HOST=192.168.10.131
DIR=/data
TMP=$DIR/tmp
MYSQL=$DIR/mysql

# grep [-acinv] [--color=auto] '搜寻字符串' filename   【查找匹配的行】【全面搜索正则表达式并把行打印出来】
# -i忽略大小写 -n显示行号 -v反向选择 -c计算匹配次数 -a对二进制文件以文本形式搜寻
# -A1 -B2  匹配行的前2行后1行也显示  -C5 匹配行的前后5行
# egrep 支持更多正则元字符集 相当于grep -E
# fgrep 指定不使用正则 相当于grep -F

# awk 'pattern + action' filenames 查询并处理 比grep更强大
# 不指定action即表示输出匹配的行
# awk -F: '/root/ {print $7}' /etc/passwd  查询/etc/passwd中匹配root的行并输出以:为分隔符分隔后的第7列
# 指定分隔符也可以这样表示 -F ":"

# tr 替换/删减

# 获取ipv4非loop不包括掩码表示的ip并用空格替换换行符
IP=$(ip a | grep inet | grep -v inet6 | grep -v 127 | awk '{print $2}' | awk -F "/" '{print $1}' | tr "\n" " ")

if [ ! -d $DIR ]; then
	mkdir $DIR
fi

if [ ! -d $TMP ]; then
    # -p 如果上级目录不存在则创建
	mkdir -p $TMP
fi

cd $TMP

# 关闭防火墙并设为开机禁用
systemctl stop firewalld && systemctl disable firewalld

# setenforce 0 临时关闭selinux
# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 永久关闭selinux
# sed 流编辑器
# -i 修改文件内容
# sed命令: s查找并替换 g全部替换
# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 将/etc/selinux/config文件中所有SELINUX=enforcing替换成SELINUX=disabled
setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 下载lib.tar.gz并解压(当前在/data/tmp/)
# 创建jdk目录 将解压出来的zxf jdk-8u181-linux-x64.tar.gz继续加压的jdk目录 【--strip-components 1 去除目录结构 1表示去除第一级目录】
# 解压autoproxy.tar.gz 
wget http://$HOST/lib/lib.tar.gz && tar zxf lib.tar.gz && mkdir jdk && tar zxf jdk-8u181-linux-x64.tar.gz -C jdk --strip-components 1 && tar zxf autoproxy.tar.gz 

# 移动jdk目录到上级目录下 即/data/下
# mv -i有同名文件时询问是否覆盖 -f不询问
# 创建jdk.sh文件并写入、追加内容 【输出重定向 >重写文件 >>追加内容】 (设置的环境变量在当前环境中并未生效 todo)
# 给jdk.sh文件添加可执行权限 并移动到/etc/profile.d目录下

# 环境变量PWD 此处值为/data/tmp/
# dirname 获取父级目录名
# $() 命令替换 同``
# ${} 变量替换 $PWD 等效 ${PWD}
mv -f jdk ../ && echo "export JAVA_HOME=$(dirname "$PWD")/jdk" > jdk.sh && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> jdk.sh && mv -f jdk.sh /etc/profile.d

# epel-release软件包：自动配置yum仓库
yum -y install epel-release 

# 安装nginx并设为开机启动
# 替换文件内容并移动到指定位置 此处是将外部nginx配置文件的servername替换成变量IP的值 (确保nginx主配置文件包含了外部配置文件，nginx的默认主配置文件没有引入外部配置文件 todo)
# 重启nginx
yum -y install nginx && systemctl enable nginx && sed -i "s/servername/$IP/g" ymxc1.conf && sed -i "s/servername/$IP/g" ymxc.conf && mv -f ymxc.conf ymxc1.conf /etc/nginx/conf.d/ && systemctl restart nginx 

# 移动脚本
# /etc/crontab中追加定时规则 每分钟执行一次看门狗【看门狗程序autoproxy watchdog.sh 自行实现】
# mv -f autoproxy watchdog.sh ymxcnc /usr/bin && echo '*/1 * * * * root watchdog.sh' >> /etc/crontab

# 安装redis并设为开机启动 重启redis
yum -y install redis && systemctl enable redis && systemctl restart redis

# 安装mysql(mariadb)并设为开机启动 替换配置文件
# 创建mysql工作目录 /data/mysql/ 修改工作目录所属用户为mysql 所属组为mysql
# 重启mysql
 
# chown[选项]...[所有者][:[组]]文件...   【改变文件的拥有者和群组】
# -R处理指定目录以及其子目录下的所有文件
yum -y install mariadb-server && cp my.cnf /etc/my.cnf && systemctl enable mariadb && mkdir -p $MYSQL && mkdir -p $MYSQL/data $MYSQL/log $MYSQL/run && chown -R mysql:mysql $MYSQL && systemctl restart mariadb

# 安装openvpn 【如有需求自行配置】
yum -y install openvpn 

# nginx配置的切换如有需求自行编写脚本

# 创建项目根目录和静态文件目录
mkdir -p $DIR/erp && mkdir -p $DIR/static
