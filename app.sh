#!/bin/bash

#----- globals-variables -----

# colors :
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


#------------------------------

downloader(){
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
}

cloud_transfer(){
    mkdir -p ~/.config/rclone
    cp ~/rclone.conf ~/.config/rclone/ 
    echo -e "\e[36m rclone set finished \e[0m"

    read -p "Enter Rclone remote name (e.g., mydrive-one): " remote_name
    read -p "Enter destination folder (e.g., Download/MOVIES): " dest_folder

    cd ~/Downloads
    echo -e "\e[36m Transfering Last Downloaded File.. \e[0m"
    latest_file=$(ls -t | awk "NR==1")
    rclone copy "$latest_file" "$remote_name:$dest_folder" -P
    echo -e "\e[36m Completed\e[em"
}

while true; do
    clear  # Clear the screen for better readability
    echo -e "$BLUE ====== MENU ====== $NC"
    echo -e "$GREEN 1) $NC qbittorrent-client (downloader)"
    echo -e "$GREEN 2) $NC transfer to cloud (rclone)"
    echo -e "$GREEN 3) $NC Quit"
    echo -e "$BLUE ================== $NC"
    read -p "Choose an option: " choice

    case $choice in
        1) downloader ;;
        2) echo "You selected Option 2";;
        3) echo "You selected Option 3";;
        4) echo "Exiting..."; exit;;
        *) echo "Invalid choice, try again!"; sleep 3;;
    esac
done
