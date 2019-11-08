#! /bin/bash

DATA=`date +%Y-%m-%d`

DATETIME=`date +"%Y-%m-%d %H:%M:%S"`

#每天定时更新有过期资质证件的供应商状态
echo ${DATETIME} 更新有过期资质证件的供应商状态 `curl -XPOST http://127.0.0.1:8112/auto/autoUpdateStatusQualificationExt` >> /data/yxcg/task/log/${DATA}.log

#每天定时更新有过期资质证件的采购商状态
echo ${DATETIME} 更新有过期资质证件的采购商状态 `curl -XPOST http://127.0.0.1:8123/customer/updateExpireQualificationStatus` >> /data/yxcg/task/log/${DATA}.log
