#!/bin/bash

#----- globals-variables -----

# colors :
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'


#------------------------------

downloader(){
    echo -e "$BLUE Downloading Qbittorrent nox...$NC"
    sudo apt install qbittorrent-nox -y
    echo -e "$BLUE Installed qbittorrent-nox $NC"
    
    sleep 1

    echo -e "$BLUE Starting qbittorrent Client $NC"
    yes | qbittorrent-nox > qbitt_out.log &
    qbit_pid=$! 
    echo -e "$BLUE wait.... $NC"

    sleep 4

    ssh -T  -o StrictHostKeyChecking=no -R 80:localhost:8080 serveo.net > serveo.log  2>&1 & 
    serveo_pid=$!
    echo -e "$BLUE wait.... $NC"

    sleep 4

    qbit=$(cat qbitt_out.log)
    serveo=$(cat serveo.log)

    echo -e "$BLUE torrent client Started... $NC"
    echo -e "$BLUE $qbit $NC"
    echo -e "$BLUE Running at : $serveo $NC"
    echo -e "$BLUE Paste the link on Browser : $NC"
    echo -e "$GREEN stop ? [enter] $NC" 
    read choise

    kill $serveo_pid
    kill $qbit_pid

    echo -e "$GREEN BYE... $NC"
}

cloud_transfer(){
    echo -e "$BLUE Installing Rclone.. $NC"
    sudo apt install rclone
    echo -e "$GREEN Installed Rclone. $NC"

    echo -e "$BLUE Do you have rclone.conf for your cloud ? [y/n] $NC"
    read ans

    if [[ $ans == "n" ]]; then
        echo "please create a rclone.conf and place it in '/home' directory."
        echo "for create rclone use command - 'rclone config'."
        exit
    fi

    mkdir -p ~/.config/rclone
    cp ~/rclone.conf ~/.config/rclone/ 
    echo -e "$BLUE rclone set finished $NC"

    read -p "Enter Rclone remote name (e.g., mydrive-one): " remote_name
    read -p "Enter destination folder (e.g., Download/MOVIES): " dest_folder

    cd ~/Downloads
    echo -e "$BLUE Transfering Last Downloaded File.. $NC"
    latest_file=$(ls -t | awk "NR==1")
    rclone copy "$latest_file" "$remote_name:$dest_folder" -P
    echo -e "$GREEN Completed $NC"

    echo -e "$GREEN Exit ? [enter] $NC"
    read choise
    
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
        2) cloud_transfer ;;
        3) echo "Exiting..."; exit;;
        *) echo "Invalid choice, try again!"; sleep 3;;
    esac
done
