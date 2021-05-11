#!/bin/bash

USERNAME="tcpdumptransfer"
DATE_DIR="$(date +"%d-%m-%Y")"
TIME="$(date +"%H%M%ss%N")"
HOUR="$(date +"%H")":00
TRACE_DIR=/m3ua
SMPP_DIR=/smpp_trace
DESTINATION_DIR=/var/cellusys/traces/${DATE_DIR}/${HOUR}
TMP_DIR=/tmp/traces/
LOG_LOCATION=/var/log/cellusys/

echo "Checking/Making destination directory..."

if [ ! -d ${DESTINATION_DIR} ]
then
    sudo mkdir -p ${DESTINATION_DIR}; sudo chown cellusys:cellusys -R ${DESTINATION_DIR};
fi

echo "Checking/Making temporary trace directory..."

if [ ! -d ${TMP_DIR} ]
then
    sudo mkdir -p ${TMP_DIR}; sudo chown cellusys:cellusys -R ${TMP_DIR};
fi

if [ ! -d ${LOG_LOCATION} ]
then
    sudo mkdir -p ${LOG_LOCATION}; sudo chown cellusys:cellusys -R ${LOG_LOCATION};
fi

echo "Transferring files using sftp..."

sudo mkdir -p ${DESTINATION_DIR}/$1; sudo chown cellusys:cellusys -R ${DESTINATION_DIR}/$1;
cd ${TMP_DIR}

if [ $1 == "10.70.12.197" ] || [ $1 == "10.74.2.197" ]
then
    SSHPASS='0iv252ai' sshpass -e sftp -l 50000 ${USERNAME}@$1:${SMPP_DIR} << ENDSFTP
    get -p *.pcap*
    quit
ENDSFTP
else
    SSHPASS='0iv252ai' sshpass -e sftp -l 50000 ${USERNAME}@$1:${TRACE_DIR} << ENDSFTP
    get -p *.pcap
    quit
ENDSFTP
fi

for file in *; do
    timestamp=$(ls -ls ${file} | awk '{print $9}')  #isolating time
    mv "${file}" "${timestamp}_${file}"
done
for newfile in *; do
    exception=$(echo ${newfile} | awk -F_ '{print $3}')
    firstchar=$(echo ${exception} | cut -c1-1)
    command=$(echo ${firstchar})
    if [[ ${command} = "S" ]]
    then
        mv "${newfile}" "${newfile%.pcap*}.pcap"
    fi
    if [[ ${newfile} =~ [A-Z] ]] && [[ ${command} != "S"  ]]
    then
#        echo yes
        rm ${newfile}
    else
#        echo no
        mv "${newfile}" "${newfile%.pcap*}.pcap"
    fi
done

rsync -av --min-size=47700k ${TMP_DIR}* ${DESTINATION_DIR}/$1
rm ${TMP_DIR}*

cd ${DESTINATION_DIR}/$1/
for finalfile in *; do
    if [ -f ${finalfile} ];
    then
        echo "Copied file ${finalfile} from $1" | sudo tee -a ${LOG_LOCATION}/ncell_sftp.log
    fi
don
e



