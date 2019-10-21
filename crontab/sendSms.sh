#! /bin/bash

DATA=`date +%Y-%m-%d`

DATETIME=`date +"%Y-%m-%d %H:%M:%S"`

#提醒供应商证件即将过期
echo ${DATETIME} 短信提醒供应商有资质证件即将过期 `curl -XPOST http://127.0.0.1:8112/auto/autoSendSmsOfQualificationUpcoming` >> /data/yxcg/task/log/${DATA}.log

#提醒供应商证件已经过期
echo ${DATETIME} 短信提醒供应商有资质证件已经过期 `curl -XPOST http://127.0.0.1:8112/auto/autoSendMessageOfQualificationExt` >> /data/yxcg/task/log/${DATA}.log

#提醒采购商证件即将过期

#提醒采购商证件已经过期
