#!/bin/bash
#
# Copyright (c) 2011 Norico - norico@tm-tnt.net
#

# repertoire du fichier de configuration
	conf='./conf'
# nom du programme
	prog_name="Tms2"

source config.[login].txt
source ./${conf}/config.sh
source ./${conf}/functions.sh

case "$1" in 
	start)		fn_do_start ;;
	stop)		fn_do_stop ;;
	restart)	fn_do_restart ;;
	status)		fn_status ;;
	create)		fn_do_create ;;
	restart)	fn_do_restart ;;	
	*)	clear
		fn_version
		echo -e "${_msg_usage}: $0 {start|stop|restart|status|create}"
	;;
esac