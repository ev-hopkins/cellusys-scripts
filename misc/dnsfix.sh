#! /bin/bash
echo "nameserver 192.168.20.101" | sudo tee -a /etc/resolv.conf > /dev/null
echo "nameserver 192.168.5.11" | sudo tee -a /etc/resolv.conf > /dev/null
echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf > /dev/null
