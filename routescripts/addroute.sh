#!/bin/bash

ROUTE_DIR=/etc/sysconfig/network-scripts
FILENAME=$1
GATEWAY=$(ip r | grep default | awk '{print $3}')
DEFAULT_SUBNET=32
SUB_CHECK=/

Help()
{
   # Display Help
   echo "This script adds routes to /etc/sysconfig/network-scripts/"
   echo 
   echo "Usage:"
   echo
   echo "addroute [<filename>] | [<IP address/subnet> <interface>]"
   echo
   echo "Lines in files suppplied should follow the folowwing format: IP address,interface,subnet"
   echo
   echo "options:"
   echo
   echo "h     Print this Help."
   echo
   echo "Syntax: addroute -h"
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

if [ -f $1 ] && [ ${FILENAME: -4} == ".txt" ] #ensures file is 
then
    count=0
    while read line; do
        count=$(( ${count} + 1 ))
        echo ${line} | grep -q "," #ensuring commas
  if [ $? -eq 1 ]
  then
      echo "Invalid format for line number ${count}: ${line} in ${FILENAME}"
        exit
  fi
    done < ${FILENAME}
    while IFS=',' read -r f1 f2 subnet; do #separates IP(f1) and interface (f2)
        if [ ! -f ${ROUTE_DIR}/route-${f2} ] #checking if given route files exist
        then
            sudo touch ${ROUTE_DIR}/route-${f2}; sudo chown evanhopkins:evanhopkins -R ${ROUTE_DIR}/route-${f2};
        fi
        if ! grep -q ${f1} ${ROUTE_DIR}/route-${f2}
        then
            sudo echo ${f1}/${subnet} via ${GATEWAY} dev ${f2} >> ${ROUTE_DIR}/route-${f2}
        fi          
    done < ${FILENAME}
elif [ $# -gt 1 ] && [ ${FILENAME: -4} != ".txt" ] && [[ $1 == *"${SUB_CHECK}"* ]] 
then
    if [ ! -f ${ROUTE_DIR}/route-${2} ] #checking if given route files exist
    then
        sudo touch ${ROUTE_DIR}/route-${2}; sudo chown evanhopkins:evanhopkins -R ${ROUTE_DIR}/route-${2};
    fi
    sudo echo ${1} via ${GATEWAY} dev ${2} >> ${ROUTE_DIR}/route-${2}
else 
    echo "Incorrectly formatted command line arguments, use -h for help"
fi
