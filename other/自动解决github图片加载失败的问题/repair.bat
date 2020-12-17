@echo off
goto comment1
	echo命令：回显
		@echo off 关闭所有命令的回显(包括本身这条命令)
		echo off  关闭所有命令的回显(不包括本身这条命令)
:comment1		

:: 设置变量
set BackupDir=%USERPROFILE%
set BackupFile=hosts.bak
set HostFile=C:\WINDOWS\system32\drivers\etc\hosts
goto comment2
	set：临时设置环境变量,注意等号右边的空格也会被当成值的一部分。如set BAT_HOME=c:\bat
		 可以用 /p 参数改成可交互方式进行设置
	setx: 永久设置环境变量(变量会添加到用户环境变量中) 可能需要管理员权限。 如setx /M BAT_HOME=c:\bat	 
:comment2

:: 创建备份文件
echo Creating backup file...
copy /y %HostFile% %BackupDir%\%BackupFile% > NUL
echo Backup file created! See: %BackupDir%\%BackupFile%
goto comment3
	copy：复制命令 /y 参数表示不提示是否覆盖
	NUL：类似于linux的/dev/null
:comment3 

:: 问题域名集合(可以放到外部文件，程序读取。或者直接放到js中进行逻辑处理)
set addresses=^
raw.githubusercontent.com ^
gist.githubusercontent.com ^
cloud.githubusercontent.com ^
camo.githubusercontent.com ^
avatars0.githubusercontent.com

:: 获取域名对应的真实ip
for %%I in (%addresses%) do (

	:: 注释真的有毒 如果无法执行 把下面的注释删了
	rem wscript getIp.vbs %addresses%  不知道为啥 这样执行之后返回403 

	curl -XPOST https://www.ipaddress.com/search/ -d {"host": "%%I"} >> %%I.txt 
	
)
	

:: 取消hosts文件的只读属性
attrib -R C:\WINDOWS\system32\drivers\etc\hosts 

::findstr /v "www.test.com"

:: 往hosts文件中追加内容
::@echo 127.0.0.1 baidu.com >>C:\WINDOWS\system32\drivers\etc\hosts 

::ipconfig /flushdns

pause