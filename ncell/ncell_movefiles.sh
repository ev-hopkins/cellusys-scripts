#!/bin/bash

DATE="$(date +"%d-%m-%Y")"
DESTINATION_DIR=/var/traces
TRACE_DIR=/var/cellusys/traces/${DATE}/
arr=("10.70.12.187" "10.70.12.188" "10.70.12.189" "10.70.12.190" "10.74.2.187" "10.74.2.188" "10.74.2.189" "10.74.2.190" "10.70.12.197" "10.74.2.197")
servernames=("KTMSig1" "KTMSig2" "KTMSig3" "KTMSig4" "POKSig1" "POKSig2" "POKSig3" "POKSig4" "KTMSmpp1" "POKSmpp1")

echo "Checking/making server dirs..."

for server in ${servernames[@]}; do
    if [ ! -d "${DESTINATION_DIR}/{server}" ]
    then
        sudo mkdir -p ${DESTINATION_DIR}/${server}
    fi
done

echo "Moving files..."

cd ${TRACE_DIR}/
i=0
for ipdir in ${arr[@]}; do 
    cd ${ipdir}
    while [ $i -lt ${#arr[*]} ]; do
        sudo mv *.pcap ${DESTINATION_DIR}/${servernames[$i]}
        cd ${DESTINATION_DIR}/${servernames[$i]}
        for f in *; do
            sudo mv "${f}" "${DATE}_${f}"
        done
        i=$(( $i + 1));
        break #i retains value
    done
    cd ${TRACE_DIR}/
done

