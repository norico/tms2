#
# Copyright (c) 2011 Norico - norico@tm-tnt.net
#
#########################################################
function fn_do_check_pid () {
	# Return Pid of server 
	pidofserver=`cat ${login_server}.pid`
	if ! test `wc -c <${login_server}.pid` -ne 0  
	then 
		pidofserver="error"
	fi
}

#########################################################
function fn_do_archive () {
	#Make archive -> fn_do_stop
	if ! test -d ./${Archives_dir} 
	then
		echo "create Archive dir"
		mkdir ./${Archives_dir}
		chmod 0640 ./${Archives_dir}
	fi
	fn_do_check_pid
	files=`cat ./${conf}/${Archives_file_list}`
	ConsoleLog="./Logs/ConsoleLog."${pidofserver}".txt"
	GameLog="./Logs/GameLog."${login_server}".txt"

	if test ${Controller} = "xaseco2"
	then
		Log_file="./xaseco2/"${login_server}"/logfile.txt"
	elif test ${Controller} = "fast4"
	then
		Log_file="./fast4/"${login_server}"/fastlog/fastlog.tm2."${login_server}".txt"
	fi
	else 
		Log_file=""
	fi

	files=${files}" "${ConsoleLog}" "${GameLog}" "${Log_file}
	echo "compressing files in ${login_server}-${pidofserver}-${DATE}.tgz"
	tar -zcvf ./${Archives_dir}/${login_server}-${pidofserver}-${DATE}.tgz ${files} --remove-files &>/dev/null
}

#########################################################
#function fn_archive_force () {
# in progress
#	if ! test -f  ${login_server}.pid
#	then
#		echo "force" > ${login_server}.pid
#	fi
#	fn_do_archive
#	rm ./${login_server}.pid
#
#}

#########################################################
function fn_do_start () {
	#Do start 
	if test -f  ${login_server}.pid
	then
		fn_do_check_pid
		echo -e "${login_server} ${_msg_is_already_online} (pid=${pidofserver})"
	else
		echo -e "${_msg_starting_server}"
		screen -AmdS ${Program_screen_name} ${cmd}
		ps aux | grep "${cmd}" | grep -v grep |grep -v SCREEN | awk '{print $2}' >> ${login_server}.pid
		echo -e ${login_server}.pid
		sleep 1

		if test ${Controller} != "none"
			echo -e "${_msg_starting_controller}"
			cd ./${Controller}/${login_server}/
			screen -AmdS ${Controller_screen_name} ./tms2-${Controller}.sh ${login_server}
			#sleep 2
			#screen -ls
		fi
	fi
} 

#########################################################
function fn_do_stop() {
	#Do stop and make archive 
	if test -f  ${login_server}.pid
	then
		echo -e "${_msg_shutting_down}"
		screen  -rX ${Program_screen_name} quit
		if test ${Controller} != "none"
			screen  -rX ${Controller_screen_name} quit
		fi
		fn_do_archive
		rm ./${login_server}.pid
	else
		echo -e "${login_server} ${_msg_is_offline}"
	fi
}

#########################################################
function fn_do_restart() {
	#Do stop and start
	
	if test -f  ${login_server}.pid
	then 	
		fn_do_stop
		sleep 2
		fn_do_start
	else
		echo -e "${login_server} ${_msg_is_offline}"
	fi
}

#########################################################
function fn_version () {
  #Return version 
  version=`cat ./${conf}/version.txt`
  echo -e "${prog_name} ${blod} ${version} ${std}"
  fn_ckeck_update
}


#########################################################
function fn_status () {
  #Return status of server
	if test -f  ${login_server}.pid ; then
		echo -e ''
		echo -e "${blod} ${login_server} ${_msg_is_online}${std}"
		echo -e ''
		srv=`ps aux | grep "${cmd}" | grep -v grep |grep -v SCREEN |  awk '{print $8, $7, $2}'`
		echo -e ${srv}
		ctrl=`ps aux | grep "${Controller_screen_name}" | grep -v grep |grep -v SCREEN | awk '{print $8, $7, $2}'`
		echo -e ${ctrl}
	else
		echo -e ''
		echo -e "${blod} ${login_server} ${_msg_is_offline}${std}"
		echo -e ''
	fi
}


#########################################################
function fn_do_create () {
	# create account files
	# check files before copy.
	# dedicated_cfg section
	if ! test -f  ./UserData/Config/dedicated_cfg.txt
	then
		msg_dedicated="d./UserData/Config/dedicated_cfg.txt ${_msg_not_exist}"
		else if test -f  ./UserData/Config/dedicated_cfg.${login_server}.txt
		then
			msg_dedicated="./UserData/Config/dedicated_cfg.${login_server}.txt ${_msg_exist}"
		fi
		# if no conflict  cp dedicated_cfg.txt -> dedicated_cfg.login.txt
		cp ./UserData/Config/dedicated_cfg.txt ./UserData/Config/dedicated_cfg.${login_server}.txt
	fi
	# MatchSetting section
	if ! test -f  ./UserData/Maps/MatchSettings/CanyonA.txt
	then
		msg_MatchSettings="./UserData/Maps/MatchSettings/CanyonA.txt ${_msg_not_exist}"
		else if test -f  ./UserData/Maps/MatchSettings/${login_server}.txt
		then
		msg_MatchSettings="/UserData/Maps/MatchSettings/${login_server}.txt ${_msg_exist}"
		fi
		# if no conflict  cp CanyonA.txt -> login.txt
		cp ./UserData/Maps/MatchSettings/CanyonA.txt ./UserData/Maps/MatchSettings/${login_server}.txt
	fi 
	

	# Fast controler cloning
	#########################################################
	if test ${Controller} = "fast4"
	then
		cp -R ./fast4/modele ./fast4/${login_server}
	fi

	# Xaseco controler cloning
	#########################################################
	if test ${Controller} = "xaseco2"
	then
		cp -R ./xaseco2/modele  ./xaseco2/${login_server}
	fi

	if test -n msg_dedicated
	then
		echo ${msg_dedicated}
		exit 1
	fi 

	if test -n msg_MatchSettings
	then
		echo ${msg_MatchSettings}
		exit 1
	fi
}


#########################################################
function fn_ckeck_update () {
	# https://raw.github.com/norico/tms2/master/conf/version.txt
	# ${conf}/version.txt
	mkdir ./tmp
	cd ./tmp
	var git_version=`wget https://raw.github.com/norico/tms2/master/conf/version.txt`
	var loc_version=`cat ${conf}/version.txt`
	if [git_version != loc_version]
	then 
		echo -e "nouvelle version disponible"
	fi 
}