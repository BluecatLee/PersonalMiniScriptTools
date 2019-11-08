#! /bin/bash


DATA=`date +%Y-%m-%d`

DATETIME=`date +"%Y-%m-%d %H:%M:%S"`

#每分钟更新平台费率
echo ${DATETIME} 更新平台费率 `curl -XPOST http://127.0.0.1:8122/boss/admin/batchUpdateBossCategoryRate` >> /data/yxcg/task/log/${DATA}.log

#更新供应商特殊费率
#echo ${DATETIME} 更新供应商特殊费率 `curl -XPOST http://127.0.0.1:8122/boss/admin/batchUpdateSupplierRate` >> /data/yxcg/task/log/${DATA}.log
