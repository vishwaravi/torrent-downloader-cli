#!/bin/bash
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