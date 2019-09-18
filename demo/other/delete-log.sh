#!/bin/bash
# 查找/data/file/目录下所有修改时间超过7天的文件并删除

# find path -option [-print]
#		-ctime +n 文件状态改变的时间 大于n(天/24h)change time
#		-atime -n 文件被读取或执行的时间 小于n access time
#		-mtime n 文件内容被修改的时间 等于n modify time
#       -name name 文件名称符合name的文件 -iname 忽略大小写
#       -type c  类型是c的文件： f表示一般文件 d表示目录

# xargs 类似于管道的作用 因为很多命令不支持管道
find /data/log/* -type f -mtime +7 | xargs rm -rf