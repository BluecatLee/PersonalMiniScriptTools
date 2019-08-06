#!/bin/bash

HOST=192.168.10.131
USER=root
PASS=pass
REMOTE_DIR=/home
LOCAL_DIR=/tmp
FILE=testfile

ftp -n <<! 
open $HOST
user $USER $PASS
passive
binary
cd $REMOTE_DIR
lcd $LOCAL_DIR
prompt
get $FILE
close
bye
!
