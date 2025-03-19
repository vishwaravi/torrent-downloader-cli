#!/bin/bash

mkdir dwn
echo -e "\e[36m Downloading Qbittorrent nox...\e[0m"

sudo apt install qbittorrent-nox -y

ssh -o StrictHostKeyChecking=no -R 80:localhost:8080 serveo.net > serveo.log &
sleep 2
echo "y" | qbittorrent-nox > qbitt_out.log 2>&1 &
sleep 1
qbit=$(cat qbitt_out.log)
serveo=$(cat serveo.log)

echo -e "\e[36m torrent client Started...\e[0m"
echo -e "\e[34m $serveo \e[0m"
echo -e "\e[32m $qbit\e[0m"

echo -e "\e[36m stop ? [enter]\e[0m" 
read choise

pkill -9 serveo
pkill -9 qbittorrent-nox
echo -e "\e[32m BYE...\e[0m"