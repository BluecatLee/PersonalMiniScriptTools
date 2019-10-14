#! /bin/bash

HOST=

# 挂载远程根目录到本机/mnt下
# sshfs只能挂载目录
sshfs root@HOST:/ /mnt

#卸载
#umount /mnt