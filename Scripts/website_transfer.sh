#!/bin/bash


run_website_transfer() {
if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
    echo -e "\n\e[91mERROR: Configuration not set!\e[0m"
    echo "Please select option 4) Configure Settings before running this option."
    read -p "Press Enter to continue..."
    return
fi

	echo -e "\n \e[93mOPTION 1: WEBSITE TRANSFER PROCESS\e[0m"
	echo "================================================================"
echo -e "\e[96mTHE PROCESS:\e[0m"
echo -e "  \e[35m├\e[0m Syncs your local website folder to the device's home directory."
echo -e "  \e[35m├\e[0m SSHs into the device to move it to the web directory (e.g., /var/www/html/)."
echo -e "  \e[35m├\e[0m Fixes file ownership & permissions for nginx to serve the site."
echo -e "  \e[35m├\e[0m Restarts web server to apply changes."
echo -e "  \e[35m├\e[0m \e[96mTHIS SCRIPT ASSUMES YOU HAVE\e[0m \e[91mSSH\e[0m \e[96mAND\e[0m \e[91mRSYNC\e[0m \e[96mINSTALLED ALONSIDE\e[0m \e[91mSUDO ACCESS\e[0m \e[96mON EACH DEVICE!\e[0m\n"

        read -p "Do you want to start syncing to $REMOTE_HOST? (y/n): " choice

        if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
            echo "Sync cancelled."
            return
        fi

        echo
        echo -e  "\e[35m1: SYNCING LOCAL FOLDER TO \e[92m$REMOTE_HOST\e[0m  \e[35mHOME DIRECTORY...\e[0m"
        total_start=$(date +%s)
        start1=$(date +%s)

        rsync -avzu --delete "$SOURCE_PATH/" "$REMOTE_HOST:~/KefkaberryLand/"

        end1=$(date +%s)
        echo "1: Time taken: $((end1 - start1))s"
        echo

        echo -e  "\e[35m2: SSH INTO DEVICE, SYNC TO \e[92m$REMOTE_WEB_DIR\e[0m \e[35mDIRECTORY, FIX PERMISSIONS AND RESTARTING WEB SERVER...\e[0m\n"
        remote_time=$(ssh "$REMOTE_HOST" "
            start2=$(date +%s)
            sudo rsync -azu --info=progress2,stats2 --delete ~/KefkaberryLand/ \"$REMOTE_WEB_DIR\" && \
            sudo chown -R www-data:www-data \"$REMOTE_WEB_DIR\" && \
	    sudo systemctl restart \"$WEB_SERVER\"
            end2=\$(date +%s)
            echo \$((end2 - start2))
        ")

        echo "2: Time taken: ${remote_time}s"
        total_end=$(date +%s)

        echo -e "\n==============================================================="
        echo "Total Time: $((total_end - total_start))s"
        echo -e "\e[35mTransfer complete. Website has been updated.\e[0m"
        echo "==============================================================="
	
	echo -e "\n\e[93mPress Enter to return to the main menu...\e[0m"
	read
}