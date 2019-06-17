#!/bin/bash
#
# set -e
PROGRAM="Ssh utility"
VERSION="1.0"
YEAR="2019"
DEVELOPER="AKAlex92"
DEBUG=true
#
# first we need to check if sshpass is installed (it's required)
if ! [ -x "$(command -v sshpass)" ]; then
	echo "The package sshpass is required."
	exit 1
fi
# first we need to check if jq is installed (it's required)
if ! [ -x "$(command -v jq)" ]; then
	echo "The package jq is required."
	exit 1
fi
# example of the json #
# {
#         "servers":
#         [
#                 {"nome":"SERVER NAME 1","host":"XX.XXX.XXX.XX","port":"1234","user":"foo","password":"abcdefg"},
#                 {"nome":"SERVER NAME 2","host":"YY.YYY.YYY.YY","port":"5678","user":"bar","password":"hilmnop"}
# 		]
# }
#
#
case $1 in
-h | --help)
	echo "$PROGRAM $VERSION"
	echo "Copyright $YEAR $DEVELOPER. All rights reserved."
	echo
	echo "Usage: sshlaunch.sh [options]"
	echo -e "Option\t\t\tLong Option\t\t\tDescription"
	echo -e "-h\t\t\t--help\t\t\t\tShow the help screen"
	echo -e "-f\t\t\t--config-file [config file]\tSpecifies the location of the config json file"
	exit 1
	;;
-f | --config-file)
	PATH_JSON=$2
	;;
*)
	if [ $DEBUG = true ]; then
		PATH_JSON="/home/ale-clion/Documenti/python_scripts/gui/config.json"
	else
		PATH_JSON="config.json"
	fi
	;;
esac
#
if [ ! -f $PATH_JSON ]; then
	echo "File $PATH_JSON doesn't exists"
	exit 1
fi
#
RECORDS=$(cat $PATH_JSON | grep '"nome"' | wc -l)
OK=0
# functions #
function connect_ssh()
{
	local OPT=$1 # $MENU CHOICE
	INDEX_CHOICHE=$((OPT-1))
	CH_HOST=$(cat $PATH_JSON | jq -r ".servers[$INDEX_CHOICHE].host")
	CH_PORT=$(cat $PATH_JSON | jq -r ".servers[$INDEX_CHOICHE].port")
	CH_USER=$(cat $PATH_JSON | jq -r ".servers[$INDEX_CHOICHE].user")
	CH_PWD=$(cat $PATH_JSON | jq -r ".servers[$INDEX_CHOICHE].password")
	sshpass -p $CH_PWD ssh -p $CH_PORT $CH_USER@$CH_HOST
}
echo "****************************************************************"
echo "Utility that read from servers json and connect to them via ssh"
echo "****************************************************************"
#
while [[ $OK -eq 0 ]];do
	COUNTER=0
	for (( I = 0; I < $RECORDS; I++))
	do
		((COUNTER++))
		NOME=$(cat $PATH_JSON | jq -r ".servers[$I].nome")
		HOST=$(cat $PATH_JSON | jq -r ".servers[$I].host")
		PORT=$(cat $PATH_JSON | jq -r ".servers[$I].port")
		echo "$COUNTER) $NOME - $HOST:$PORT"
	done
	echo -n "Choose menù option [1 - $COUNTER] (0 = exit): "
	read MENU
	OK=1
	# check if valid input (only number and between choiches)
	#
	if [[ "$MENU" =~ ^[0-9]+$ ]]; then # check if input is only integers
		if [[ $MENU -eq 0 ]]; then
			echo "Closing utility..."
			exit 0
		fi
		if [[ $MENU -lt  0 || $MENU -gt $COUNTER ]]; then
			echo "Please choose a valid option from the menù between 1 and $COUNTER"
			OK=0
		fi
	else
		echo "Please choose a valid option from the menù. Only numbers are allowed."
		OK=0
	fi
	sleep 2
done

if [[ $OK -eq 1 ]]; then
	echo "Connecting to Server..."
	connect_ssh $MENU
fi
