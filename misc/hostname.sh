#! /bin/bash

config_hostname (){
echo Enter hostname: 
     read HOSTNAME
     echo Enter domain-name:
     read DOMAIN

sudo hostnamectl set-hostname $HOSTNAME.$DOMAIN
sudo hostnamectl 
IPADDRESS=$(sudo hostname -I)

sudo rm /etc/hosts

sudo echo "127.0.0.1 localhost localhost.localdomain
$IPADDRESS $HOSTNAME.$DOMAIN $HOSTNAME" | sudo tee -a /etc/hosts

sudo /etc/init.d/network restart
}

while true; do
     read -p "Configure hostname and domain-name? y or n: " yn
     case $yn in
          [Yy]* ) config_hostname; break;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no";;
     esac
done
