#! /bin/bash

/usr/sbin/openvpn --daemon --writepid /var/run/openvpn/server.pid --config server.conf --cd /etc/openvpn

#--daemon  		初始化后以守护进程运行
#--writepid		主线程id写入文件
#--config		从配置文件读取配置
#--cd			初始化之前进入指定目录