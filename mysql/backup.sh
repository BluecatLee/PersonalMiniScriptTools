#!/bin/bash

DATE=`date +%Y-%m-%d-%H`

mysqldump -uroot -pxx testdb >/home/backup/${DATE}.sql
