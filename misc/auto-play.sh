#First Param = Machine IP
#Second Param = Transport Protocl
#Third Param = Message Protocol
#Fouth Param = Port


DATE_DIR="$(date +"%d-%m-%Y")"
LATEST_HOUR=$(ls -rt /var/cellusys/traces/$DATE_DIR | tail -n 2 | head -n 1)
LATEST_HOUR_FORMATTED="${LATEST_HOUR:0:2}\\${LATEST_HOUR:2}"
TRACE_DIR="/var/cellusys/traces/$DATE_DIR/$LATEST_HOUR_FORMATTED/$1"

#smpp server 1
if [ $1 == "10.70.12.197" ]
then
    sudo sed -i "s|path.*|path \"$TRACE_DIR\"|g" /etc/cellusys/signalling-test-tools/config.edn
    sudo sed -i "/:connection {:protocol/s/.*/ :connection {:protocol $2/" /etc/cellusys/signalling-test-tools/config.edn
    awk -v smpp=$4 '/:port [0-9]*/{c+=1}{if(c==4){sub(":port [0-9]*",":port " smpp,$0)};print}' /etc/cellusys/signalling-test-tools/config.edn > tmp && sudo mv tmp /etc/cellusys/signalling-test-tools/config.edn #Replaces the fourth occurrence of ":port" with the port number for the connection to this server
    sudo sed -i "/:protocol {:input-protocol/s/.*/ :protocol {:input-protocol $3}}/" /etc/cellusys/signalling-test-tools/config.edn

#smpp server 2
elif [ $1 == "10.74.2.197" ]
then
    sudo sed -i "s|path.*|path \"$TRACE_DIR\"|g" /etc/cellusys/signalling-test-tools/config.edn
    sudo sed -i "/:connection {:protocol/s/.*/ :connection {:protocol $2/" /etc/cellusys/signalling-test-tools/config.edn
    awk -v smpp=$4 '/:port [0-9]*/{c+=1}{if(c==4){sub(":port [0-9]*",":port " smpp,$0)};print}' /etc/cellusys/signalling-test-tools/config.edn > tmp && sudo mv tmp /etc/cellusys/signalling-test-tools/config.edn #Replaces the fourth occurrence of ":port" with the port number for the connection to this server
    sudo sed -i "/:protocol {:input-protocol/s/.*/ :protocol {:input-protocol $3}}/" /etc/cellusys/signalling-test-tools/config.edn

#everything else
else
    sudo sed -i "s|path.*|path \"$TRACE_DIR\"|g" /etc/cellusys/signalling-test-tools/config.edn
    sudo sed -i "/:connection {:protocol/s/.*/ :connection {:protocol $2/" /etc/cellusys/signalling-test-tools/config.edn
    sudo sed -i "/:protocol {:input-protocol/s/.*/ :protocol {:input-protocol $3}}/" /etc/cellusys/signalling-test-tools/config.edn
fi



sudo service signalling-test-tools restart








#/var/cellusys/traces/26-08-2020/00:00/10.70.12.187
