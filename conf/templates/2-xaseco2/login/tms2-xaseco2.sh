#!/bin/bash
#
# Copyright (c) 2011 Norico - norico@tm-tnt.net
#
while [[ true ]]; do
    if test -n ${login_server}
    then
        login=${login_server}
    else
        login="Xaseco-unknow"
    fi
    # auto-reload Xaseco on online shutdown.
    php_location=`which php`
    ${php_location} xaseco2.php $login
done