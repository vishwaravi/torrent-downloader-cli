#!/bin/bash
mkdir -p ~/.config/rclone
cp ~/rclone.conf ~/.config/rclone/ 
echo -e "\e[36m rclone set finished \e[0m"

if [[ $1 == "latest" ]]; then
	cd ~/Downloads
	latest_file=$(ls -t | awk "NR==1")
	rclone copy "$latest_file" mydrive-one:Download/MOVIES -P
fi
echo -e "\e[36m Completed\e[em"