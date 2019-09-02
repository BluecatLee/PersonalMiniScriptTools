#!/bin/bash

########################################################
# 基于maven的项目版本更新及打包发布到远程仓库(如gitlab)#
# 请修改项目id token url                               #
########################################################

# Install Git Bash first.
# Execution path must be pure english.
# Remind to custome your configs.

# 定义VERSION变量表示当前脚本版本信息
VERSION=0.0.1

# $0 表示当前shell脚本文件名(带路径)
# dirname 获取当前文件的目录名
# 定义BASE_PATH变量表示根目录路径
BASE_PATH=$(cd `dirname $0`; cd ..; pwd) 

# POM版本信息
# 定义POM变量标识父pom文件
POM=$BASE_PATH/pom.xml

# awk [-Field-separator] 'commands' input-file(s)
# awk 域分隔符(默认空格) 命令       输入文件
# awk '/<version>[^<]+<\/version>/' pom.xml   表示获取pom.xml文件中所有包含<version></version>的行 且<version></version>中间一定有字符且不为<
# awk '/<version>/' pom.xml   				  表示获取pom.xml文件中所有包含<version>的行 
# gsub（regx,substituion,target) awk内置的替换函数
# gsub(/<version>|<\/version>/,"",$1);  
#		$1：表示第一域 即第一次出现<version>xx</version>的地方 (注意:因此pom文件中本身的版本信息必须写在最前面) 用空串替换|位置的内容 即删除版本号
# 获取当前pom文件中的版本号信息 并存到POM_VRESION变量中
POM_VERSION=`awk '/<version>[^<]+<\/version>/{gsub(/<version>|<\/version>/,"",$1);print $1;exit;}' $POM`

# $1 表示执行该脚本所添加的第一个参数
# 定义变量PARAM 接收第一个参数
PARAM=$1

# 定义AUTO_VERSION变量 表示是否自动版本
AUTO_VERSION=false

# 定义变量PROJECT_ID 表示当前项目序号
PROJECT_ID=【项目id】

# 定义变量PROJECT 表示当前项目名称
PROJECT=app

# 定义变量TOKEN 用于调用Gitlab API时的验证
TOKEN=【token】

# 帮助
# 定义函数usage 输出以下内容并退出 1表示非正常退出 0表示正常退出
# Deploy version $VERSION
# Usage: deploy [version(x.x.x.x)]
# 如果执行该脚本带了参数的话也会输出 并发出报警声音(-e 参数的作用)
function usage() {
    echo "Deploy version $VERSION"
    echo "Usage: deploy [version(x.x.x.x)]"
    if [ "$1" != "" ]; then
        echo -e $1
    fi
    exit 1
}

# 新版本
# 定义函数newVersionFromPom (注意：函数中定义的变量依然是全局生效的)
function newVersionFromPom() {
	# 将传入函数的第一个参数赋值给变量LEFT_VERSION 此时即不带-SNAPSHOT的旧的版本号 例如1.0.0.1
    LEFT_VERSION=$1

	# ${}变量替换： 
	#		%%.* 表示拿掉第一个.及其右边所有字符串；   
	#       %.* 表示拿掉最后一个.及其右边所有字符串；
	#       #*. 表示拿掉第一个.及其左边的字符串；
	#       ##*. 表示拿掉最后一个.及其左边的字符串；
	# OV表示主版本号 
    OV=${LEFT_VERSION%%.*}
    LEFT_VERSION=${LEFT_VERSION#*$OV.}

	# TV表示次版本号
    TV=${LEFT_VERSION%%.*}
    LEFT_VERSION=${LEFT_VERSION#*$TV.}

	# SV表示修订号
    SV=${LEFT_VERSION%%.*}
    LEFT_VERSION=${LEFT_VERSION#*$SV.}

	# FV表示内部版本号
    FVT=${LEFT_VERSION%%.*}
    FV=${FVT%-*}
	
	# 内部版本号加1后拼接成新的版本号
	# 函数中使用return 或echo返回。 return只能返回数值型
    echo $OV.$TV.$SV.$(($FV+1))-SNAPSHOT
}

# 定义变量BANNER 表示banner图
BANNER='
    ___                  _
   (  _ \               (_ )
   | | ) |   __   _ _    | |    _    _   _
   | | | ) / __ \(  _ \  | |  / _ \ ( ) ( )
   | |_) |(  ___/| (_) ) | | ( (_) )| (_) |
   (____/  \____)| ,__/ (___) \___/  \__, |
                 | |                ( )_| |
                 (_)                 \___/
'

# 输出banner图
echo -e "$BANNER"

# 如果参数为rollback 则输出Rollback 回退版本号 并正常退出 
if [ "$PARAM" == "rollback" ]; then
    echo "Rollback "
	#  mvn versions:commit执行前且versionsBackup存在时执行revert有效
    mvn versions:revert -f $POM
    exit 0
fi

# 如果参数为空 则将POM_VERSION变量赋值给PARAM变量 同时设置AUTO_VERSION变量的值为true
if [ "$PARAM" == "" ]; then
    PARAM=$POM_VERSION
    AUTO_VERSION=true
fi

# ~ 表示匹配后面的正则
if [[ "$PARAM" =~ ^[0-9]+.[0-9]+.[0-9]+.[0-9]+(-SNAPSHOT)?$ ]]; then
    # 打包
	
	# ${} 在bash中用来变量替换
	# ${}用法 ： %表示去掉右边 %-*表示去掉最后一个-及其右边所有字符串
	# 将不带-SNAPSHOT的版本号赋值给变量OLD_VERSION
    OLD_VERSION=${PARAM%-*}
	# $()和`` 在bash中用来命令替换
	# `` 内一般存放命令 可以将命令的结果赋值给一个变量
	# 调用newVersionFromPom函数并传入参数OLD_VERSION，将函数返回值赋值给变量NEW_VERSION
    NEW_VERSION=`newVersionFromPom $OLD_VERSION`
	# read用于从标准输入读取值 -p表示在输入前打印提示信息 并将读入的值记录到变量yesOrNo中
    read -p "Are you sure to continue (release version $OLD_VERSION, new version $NEW_VERSION)? [Y/N]" yesOrNo
    case $yesOrNo in
        [yY]*)
            echo "Update release version $OLD_VERSION"
			# 将当前项目中父子模块的版本号全部设置为OLD_VERSION 
            mvn versions:set -DnewVersion=$OLD_VERSION -f $POM
			# 打包 并跳过测试
            mvn package -DskipTests -f $POM
			
			# $? 表示上一个命令执行后的退出状态 0表示正常退出
			# -eq 仅用户Integer类型的比较 =可用于String、Integer类型的比较
            if [[ $? -eq '0' ]]; then
			
				# curl
				# -s 静默模式Silent 不输出任何信息
				# -X/--request <command>          指定请求类型
				# -H/--header <line>              自定义头信息传递给服务器
				# -F/--form <name=content>        模拟http表单提交数据
				# -d/--data <data>                HTTP POST方式传送数据
				
				# 将打包过后的jar包上传到Gitlab中  参考Gitlab API
				# 将上传结果保存到变量ret中
				# 返回示例 {"alt":"app-1.0.0.12.jar","url":"/uploads/xxxxx/app-1.0.0.12.jar","markdown":"[app-1.0.0.12.jar](/uploads/xxxxx/app-1.0.0.12.jar)"}
                ret=$(curl -s --request POST --header "PRIVATE-TOKEN: $TOKEN" --form "file=@$BASE_PATH/$PROJECT/target/app-$OLD_VERSION.jar" http://gitlab.yegoo.cc/api/v4/projects/${PROJECT_ID}/uploads)
				# 将变量ret值的markdown":" 前面所有字符串去掉 并保存到变量markdown1中
				# 此时markdown1值为 [app-1.0.0.12.jar](/uploads/xxxxx/app-1.0.0.12.jar)"}
                markdown1=${ret#*markdown\":\"}
				# ${}中 :表示提取字符串
				# 提取第一个字符开始到倒数第二个字符
				# 此时msg的值为[app-1.0.0.12.jar](/uploads/xxxxx/app-1.0.0.12.jar)
                msg=${markdown1:0:-2}
                # 打tag包并且提交
				# 创建标签并推送到远程仓库 
				# git push origin [tagname] 推送一个标签
				# git push origin --tags    推送所有标签
                git tag -a v$OLD_VERSION -m "$OLD_VERSION"
                git push origin v$OLD_VERSION
                if [[ $? -eq '0' ]]; then
					# tag上传成功后 删除本地tag
                    git tag -d v$OLD_VERSION
                    echo "Update next version $NEW_VERSION"
					# 修改版本为新版本 会自动生成versionsBackup文件
                    mvn versions:set -DnewVersion=$NEW_VERSION -f $POM
					# 确定修改版本 versionsBackup文件会删除
                    mvn versions:commit -f $POM
                else
					# tag上传失败 回滚对版本的修改
                    mvn versions:revert -f $POM
                fi
                data="# Release v$OLD_VERSION $msg"
				# echo curl -s --request POST --header "PRIVATE-TOKEN: $TOKEN" --data "description=$data" http://gitlab.yegoo.cc/api/v4/projects/${PROJECT_ID}/repository/tags/v$OLD_VERSION/release
				# 将上传的jar包关联到Gitlab对应project的respository/tag下
                ret=$(curl -s --request POST --header "PRIVATE-TOKEN: $TOKEN" --data "description=$data" http://gitlab.yegoo.cc/api/v4/projects/${PROJECT_ID}/repository/tags/v$OLD_VERSION/release)
                echo $ret
            else
                 mvn versions:revert -f $POM
            fi
            ;;
        [nN]*)
            echo "exit"
			# exit 退出 如果不指定退出码,则退出码为最后一个命令的退出码
            exit
            ;;
        *)
            echo "Just enter Y or N, please."
            exit
            ;;
    esac
else
    # 版本号格式不对 输出异常信息
    if $AUTO_VERSION; then
        usage "pom version error, you must init pom version x.x.x.x\nex: deploy.sh 1.0.0.1"
    else
        usage "input version error"
    fi
fi