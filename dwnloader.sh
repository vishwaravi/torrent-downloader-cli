#!/bin/bash

echo -e "\e[36m Downloading Qbittorrent nox...\e[0m"
sudo apt install qbittorrent-nox -y
echo -e "\e[36m Installed qbittorrent-nox \e[0m"
sleep 1

echo -e "\e[36m Starting qbittorrent Client \e[0m"
yes | qbittorrent-nox > qbitt_out.log &

qbit_pid=$! 

echo -e "\e[36m wait.... \e[0m"

sleep 4

ssh -T  -o StrictHostKeyChecking=no -R 80:localhost:8080 serveo.net > serveo.log  2>&1 & 

serveo_pid=$!

echo -e "\e[36m wait.... \e[0m"

sleep 4

qbit=$(cat qbitt_out.log)

serveo=$(cat serveo.log)

echo -e "\e[36m torrent client Started...\e[0m"
echo -e "\e[32m $qbit \e[0m"
echo -e "\e[36m Running at : $serveo \e[0m"
echo -e "\e[36m Paste the link on Browser : \e[0m"

echo -e "\e[36m stop ? [enter] \e[0m" 
read choise

kill $serveo_pid
kill $qbit_pid

echo -e "\e[32m BYE...\e[0m"