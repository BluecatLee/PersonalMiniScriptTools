#!/bin/bash
# this is script to nginx
# 此脚本用来切换nginx的配置 比如可以注释/放开注释nginx主配置文件的include文件


# sed [options] 'command' file(s)
# sed -i 's/原字符串/新字符串/' file
if [ $1 == offline ];then
# 此处表示去掉94行行首的#字符
sed -i '94s/^#//' /data/nginx/conf/nginx.conf && sed -i '93s/^/#/' /data/nginx/conf/nginx.conf && nginx -s reload
elif [ $1 == online ];then
sed -i '93s/^#//' /data/nginx/conf/nginx.conf && sed -i '94s/^/#/' /data/nginx/conf/nginx.conf && nginx -s reload
else
echo "hava no execute!"
fi