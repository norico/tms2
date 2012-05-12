#!/bin/bash
#
# Copyright (c) 2012 Norico - norico@tm-tnt.net
#
login_server=$1;
while [[ true ]]; do
    if test -n ${login_server}
    then
        login=${login_server}
   else
        login="fast4-unknow"
    fi
    # auto-reload Xaseco on online shutdown.
    php_location=`which php`
    ${php_location} fast.php ../../UserData/Config/dedicated_cfg.${login_server}.txt
done