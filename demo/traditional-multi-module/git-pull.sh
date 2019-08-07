#!/bin/bash

# 使环境变量生效
# 在当前bash环境中执行/etc/profile中的命令 可以无执行权限
# 与./etc/profile等效 source是bash shell的内置命令 .是Bourne Shell的命令
source /etc/profile

# pushd 切换目录
# pushd /data/code/demo-java 表示将该目录push到栈中 同时会切换到这个目录 再次执行pushd则会回到前一个目录
# popd 表示将栈顶目录弹出
# 此处表示切换到/data/code/demo-java 忽略父pom文件的修改 防止冲突 拉代码 并切换回原目录
pushd /data/code/demo-java && git checkout /data/code/demo-java/pom.xml && git pull && popd


# cp 复制 -f表示强制
#/bin/cp -f /data/code/demo-java/pom.xml /data/code/demo-java/pom.xml.1
# sed :流编辑器
# sed [options] 'command' file(s)
#     -i ：直接修改读取的文件内容，而不是输出到终端
# 		   sed -i 's/原字符串/新字符串/' file
#sed -i 's/【ip1】/【ip2】/' /data/code/demo-java/pom.xml