#
# Copyright (c) 2012 Norico - norico@tm-tnt.net
#

Program="ManiaPlanetServer"

Template_dir=${conf}"/templates"


ManiaPlanet-Server-Lastest="http://files.maniaplanet.com/tools/ManiaPlanetDedicated_2012-01-17.zip"
Fast4-Lastest="http://slig.info/fast4.0/fast4.0.0n.zip"
xaseco2-Lastest="http://www.gamers.org/tm2/xaseco2_100.zip"


Dedicated="dedicated_cfg.${login_server}.txt"
MatchSetting="MatchSettings/${login_server}.txt"

Title="/title=TMCanyon"
Demon="/nodaemon"
Internet="/internet"
Validation="/validation=${validation_code}"

Options=""

Archives_dir="./archives"
Archives_file_list="files_list_to_tar.txt"

Program_screen_name="${Program}_${login_server}"
Controller_screen_name="${Controller}_${login_server}"


#ligne de commande
cmd="./${Program} /game_settings=${MatchSetting} /dedicated_cfg=${Dedicated} ${Title} ${Demon} ${Internet} ${Validation} ${Options}"

#formatage de la date
DATE=`date +%F`s

#couleurs
green='\e[0;32m'
red='\e[0;31m'
white='\e[1;37m'
yellow='\e[1;33m'
blod="\033[1m"
std="\033[0m"


if test -f ${conf}/lang/${lang}
	then 
		source ${conf}/lang/${lang}
	else
		source ${conf}/lang/en
fi