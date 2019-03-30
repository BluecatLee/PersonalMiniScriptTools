#!/bin/bash

# Change Git Config
# Install Git Bash first
# Remind to custome your configs

PREFIX='[Git Config:]'

BANNER='
          _   _                               __   _         
   __ _  (_) | |_      ___    ___    _ __    / _| (_)   __ _ 
  / _` | | | | __|    / __|  / _ \  |  _ \  | |_  | |  / _` |
 | (_| | | | | |_    | (__  | (_) | | | | | |  _| | | | (_| |
  \__, | |_|  \__|    \___|  \___/  |_| |_| |_|   |_|  \__, |
  |___/                                                |___/ 
'

echo -e "$BANNER"

echo -e "$PREFIX Current git config list:"

git config --list

read -p "$PREFIX Are you sure to continue (change git config)? [Y/N/P/W]
 Y: 是 并且指定config name修改
 N: 否
 P: 快速模式(切换到个人状态)
 W: 快速模式(切换到工作状态)
 " arg
 
case $arg in
	[pP]*)
		git config --global user.name "BluecatLee"
		git config --global user.email "jiaobujun@163.com"
		git config --global --unset commit.template
		
		echo "$PREFIX Change Success, current config is Personal."
		sleep 5
		;;
	[wW]*)
		git config --global user.name "{workname}"  # modify
		git config --global user.email "{workemail}"  # modify
		git config --global commit.template "{templatePath}"  # modify
		
		echo "$PREFIX Change Success, current config is Enterprise."
		sleep 5
		;;
	[yY]*)
		for ((;;));	
		do
			read -p "$PREFIX Enter the config name you want to change : " key
			read -p "$PREFIX Enter the config value you want to change : " value
			
			git config --global $key "$value"
			
			read -p  "$PREFIX Set $key = $value Success. contine change? [Y/N]" con
			case $con in 
				[nN]*)
					break
			esac	
				
		done
		
		
		sleep 5
		;;
	[nN]*)
		echo "$PREFIX Exit"
		sleep 3
		exit
		;;
	*)
		echo "$PREFIX Just enter Y、N、P、W, please."
		sleep 3
		exit
		;;
esac