#!/bin/bash

ROUTE_DIR=/etc/sysconfig/network-scripts
FILE=${1}
ROUTE_FILE=/etc/sysconfig/network-scripts/route-${2}
SUB_CHECK=/

Help()
{
   # Display Help
   echo "This script removes routes in given files from /etc/sysconfig/network-scripts/"
   echo
   echo "Usage:"
   echo
   echo "removeroute <ip address> <interface>"
   echo
   echo "options:"
   echo
   echo "h     Print this Help."
   echo
   echo "Syntax: removeroute -h"
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

if [ $# -eq 0 ]
then
    Help
    exit
fi


if [ $# -gt 0 ] #&& [[ $1 == *"${SUB_CHECK}"* ]]
then
    echo "Removing route..."
    sed -i "/${1}/d" ${ROUTE_FILE}
    sleep 0.5
    cat ${ROUTE_FILE}
fi

