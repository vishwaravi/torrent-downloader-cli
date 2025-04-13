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

    if ! command ngrok -v &> /dev/null; then
        echo -e "$BLUE Ngrok not Found. Installing... $NC"
        curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	    | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	    | sudo tee /etc/apt/sources.list.d/ngrok.list \
	    && sudo apt update \
	    && sudo apt install ngrok
    fi
    
    sleep 1
    ngrok config add-authtoken 2uet4N88Q30raXN0CpCHKjGHzRQ_6h91okzoEFMet2Ub8EFLN
    
    echo -e "$BLUE Starting qbittorrent Client $NC"
    yes | qbittorrent-nox > qbitt_out.log 2>&1 &

    sleep 3

    qbit=$(cat qbitt_out.log)
    
    ngrok http --url=romantic-buffalo-openly.ngrok-free.app 8080 > ltunnel.log 2>&1 &

    echo -e "$BLUE wait.... $NC"
    sleep 2


    echo -e "$GREEN torrent client Started... $NC"
    echo -e "$BLUE $qbit $NC"
    echo -e "$GREEN Running at : https://romantic-buffalo-openly.ngrok-free.app $NC"
    echo -e "$BLUE Paste the link on Browser : $NC"
    echo -e "$GREEN stop ? [enter] $NC" 
    read choise

    pkill pkill ngrok
    pkill qbittorrent-nox

    echo -e "$GREEN BYE... $NC"
}

cloud_transfer(){
    echo -e "$BLUE Installing Rclone.. $NC"
    sudo apt install rclone -y
    echo -e "$GREEN Installed Rclone. $NC"
    sudo apt install fzf -y
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
    selected_content=$(ls -t | fzf)
    echo -e "$BLUE Selected $selected_content $NC"
    sudo rclone copy "$selected_content" "$remote_name:$dest_folder" -P
    echo -e "$GREEN Completed $NC"
    echo -e "$GREEN Exit ? [enter] $NC"
    read choise
    d_state="active"
    
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
