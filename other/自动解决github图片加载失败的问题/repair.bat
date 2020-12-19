@echo off 
rem 必须以管理员身份运行
rem dont ask question.  just practice.
goto comment1
	echo命令：回显
		@echo off 关闭所有命令的回显(包括本身这条命令)
		echo off  关闭所有命令的回显(不包括本身这条命令)
:comment1		

:: 设置变量
set BackupDir=%USERPROFILE%
set BackupFile=hosts.bak
set HostFile=C:\WINDOWS\system32\drivers\etc\hosts
set TmpDir=%USERPROFILE%\Desktop
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
gist.github.com^
 assets-cdn.github.com^
 raw.githubusercontent.com^
 gist.githubusercontent.com^
 cloud.githubusercontent.com^
 camo.githubusercontent.com^
 avatars0.githubusercontent.com^
 avatars1.githubusercontent.com^
 avatars2.githubusercontent.com^
 avatars3.githubusercontent.com^
 avatars4.githubusercontent.com^
 avatars5.githubusercontent.com^
 avatars6.githubusercontent.com^
 avatars7.githubusercontent.com^
 avatars8.githubusercontent.com


:: 获取域名对应的真实ip
for %%I in (%addresses%) do (

	:: 注释真的有毒 如果无法执行 把下面的注释删了
	rem wscript getIp.vbs %addresses%  不知道为啥 这样执行之后返回403 

	rem curl -L --connect-timeout 10 -m 90 -XPOST https://www.ipaddress.com/search/ -d {"host": "%%I"} >> %%I.html

	rem for /f "tokens=1,* delims=." %%i in ("%addresses%") do (
  	rem	rem echo %%i
	rem	rem echo %%j
	rem	rem 变量延迟
	rem	rem setlocal enabledelayedexpansion
  	rem	set secondRealm=%%j
	rem	goto :got
	rem )
	rem :got
	:: 下载页面
	:: 无法下载 网站有限制 如何处理？
	rem curl -kIvL -e "; auto" --connect-timeout 10 -m 90 https://%secondRealm%.ipaddress.com/%addresses% >> %TmpDir%\%addresses%.html

	

	setlocal enabledelayedexpansion
	set /a row=0
	for /f "tokens=*" %%t in ('nslookup %%I 8.8.8.8') do (
		set /a row+=1
		rem echo !row!
		if !row!==4 (
		    	set  var=%%t
			rem 获取到的ip
			rem echo !var:~10!
			rem echo  %%I
			echo !var:~10! %%I>>%systemroot%/System32/drivers/etc/hosts
			
			rem  dns污染? 依旧没有获取到新的正确的ip
			rem  事实上的有效ip: 199.232.96.133
			if %%I equ gist.github.com (echo  > NUL) else if %%I equ assets-cdn.github.com (echo  > NUL) else (
				echo 199.232.96.133 %%I>>%systemroot%/System32/drivers/etc/hosts
			)

		)
	)

)
	
ipconfig /flushdns

pause

