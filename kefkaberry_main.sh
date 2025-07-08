#!/bin/bash


SOURCE_PATH=""
REMOTE_HOST=""
REMOTE_WEB_DIR=""


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/Scripts/website_transfer.sh"
source "$SCRIPT_DIR/Scripts/configure_settings.sh"
source "$SCRIPT_DIR/Scripts/main_menu.sh"
source "$SCRIPT_DIR/Scripts/Manage_Backups.sh"

CONFIG_FILE="$SCRIPT_DIR/WebsiteTransferConfig.cfg"

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

check_config() {
    if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
        echo -e "\nCONFIG NOT SET!\n"
        echo "Please select '2) Configure Settings' to set up the required filepaths before running."
        return 1
    fi
    return 0
}

while true;do

main_menu

if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
    echo -e "\n\e[35m[CONFIG NOT SET!!!!!]\e[0m"
    echo -e "\e[93mPlease select '4) Configure Settings' immediately to set up your website transfer.\e[0m\n"
fi




    echo -e "\e[93mSelect an option below:\e[0m"

if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
    echo -e " \e[90m 1)  Start Website Transfer (Configure settings first)\e[0m"
    echo -e " \e[90m 2)  Run Website Status Check (Configure settings first)\e[0m"
    echo -e " \e[90m 3)  Check Contents (Configure settings first)\e[0m"
else
    echo -e " \e[93m 1)\e[0m  Start Website Transfer"
    echo -e " \e[93m 2)\e[0m  Run Website Status Check"
    echo -e " \e[93m 3)\e[0m  Check Contents"
fi
    echo -e " \e[93m 4)\e[0m  Settings"
    echo -e " \e[93m 5)\e[0m  \e[92mHelp\e[0m"
    echo -e " \e[93m 6)\e[0m  Exit"
    read -p "Select Option [1-6]: " option
    echo

case $option in
    1) run_website_transfer;;

    2)

	if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
    		echo -e "\n\e[91mERROR: Configuration not set!\e[0m"
    		echo "Please select option 4) Configure Settings before running this option."
		read -p "Press Enter to continue..."
    		continue
	fi

        echo -e "\n \e[93mOPTION 2: REMOTE WEBSITE STATUS CHECK\e[0m"
        echo "================================================================"
        echo
        check_config || continue

        echo -e "\e[35mRunning Website Status Check on $REMOTE_HOST...\e[0m"
	  ssh "$REMOTE_HOST" "
	  export DOMAIN='$DOMAIN'
	  export STATUS_CHECKS_ENABLED='$STATUS_CHECKS_ENABLED'
	  bash -s" < "$SCRIPT_DIR/Website_Status_Check.sh"
        echo
	echo -e "\n\e[93mPress Enter to return to the main menu...\e[0m"
	read
        ;;

    3)


        if [[ -z "$SOURCE_PATH" || -z "$REMOTE_HOST" || -z "$REMOTE_WEB_DIR" || -z "$WEB_SERVER" ]]; then
                echo -e "\n\e[91mERROR: Configuration not set!\e[0m"
                echo "Please select option 4) Configure Settings before running this option."
                read -p "Press Enter to continue..."
                continue
        fi


            echo -e "\n \e[93mOPTION 3: CHECK REMOTE CONTENTS\e[0m"
            echo "================================================================"
            echo
            check_config || continue

            echo -e "\e[35mDirectory Listing of $REMOTE_WEB_DIR on $REMOTE_HOST:\e[0m"
            ssh "$REMOTE_HOST" "ls -lahC --group-directories-first '$REMOTE_WEB_DIR'"
            echo
	echo -e "\n\e[93mPress Enter to return to the main menu...\e[0m"
	read
            ;;

4) 
    run_configure_settings "$CONFIG_FILE" "$SOURCE_PATH" "$REMOTE_HOST" "$REMOTE_WEB_DIR" "$WEB_SERVER" "$BACKUP_PATH"
    if [[ $? -eq 0 && -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
        echo -e "\n\e[92mConfiguration reloaded successfully.\e[0m"
	  else
    		echo -e "\n\e[93mNo changes saved, configuration not reloaded.\e[0m"
    fi
    read -p "Press Enter to continue..."
    ;;


	5)

	    echo -e "\n \e[93m=== HELP ===\e[0m"
	    "$SCRIPT_DIR/WebsiteUploaderHelp.sh" | less -R
	    ;;
        6)
            echo "Exiting script, Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please select 1, 2, 3, or 4."
            ;;
esac
done
