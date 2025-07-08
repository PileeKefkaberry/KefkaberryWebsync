#!/bin/bash
echo "[DEBUG] configure_settings.sh loaded"


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/Scripts/Manage_Backups.sh"
source "$SCRIPT_DIR/Scripts/set_healthcheck.sh"

run_configure_settings() {
    CONFIG_FILE="$1"
    SOURCE_PATH="$2"
    REMOTE_HOST="$3"
    REMOTE_WEB_DIR="$4"
    WEB_SERVER="$5"
    SET_STATUSCHECK="$6"

main_menu



    echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    echo -e "\n\e[1;35mMENU\e[0m\n"

while true;do
	echo -e "\e[96mWhich setting would you like to configure?\e[0m\n"
	echo -e " \e[93m 1)\e[0m  Edit Directory Paths"
	echo -e " \e[93m 2)\e[0m  Manage Backups"
	echo -e " \e[93m 3)\e[0m  Manage Website Status Check"
	echo -e " \e[93m 4)\e[0m  Exit"

        read -p "Select Setting: [1-4] " setting_choice



case "$setting_choice" in

 1)
                echo -e "\n\e[93m--- Configure Filepaths ---\e[0m"
    while true; do
        read -p "Enter LOCAL SOURCE folder path [$SOURCE_PATH]: " new_source

        if [[ -z "$new_source" ]]; then
            new_source="$SOURCE_PATH"
            break
        fi

        if [[ -d "$new_source" ]]; then
            break
        else
            echo -e "\e[91mDirectory does not exist! Please enter a valid directory path.\e[0m"
        fi
    done

    read -p "Enter REMOTE SSH hostname [$REMOTE_HOST]: " new_host
    read -p "Enter REMOTE WEB directory path [$REMOTE_WEB_DIR]: " new_web_dir
    read -p "Which web server do you want to restart on the Raspberry Pi? (nginx/apache) [$WEB_SERVER]: " new_web_server
    new_web_server="${new_web_server:-$WEB_SERVER}"

    while [[ "$new_web_server" != "nginx" && "$new_web_server" != "apache" ]]; do
        echo -e "\e[91mInvalid choice! Please enter 'nginx' or 'apache'.\e[0m"
        read -p "Which web server do you want to restart on the Raspberry Pi? (nginx/apache) [$WEB_SERVER]: " new_web_server
        new_web_server="${new_web_server:-$WEB_SERVER}"
    done

    old_source="$SOURCE_PATH"
    old_host="$REMOTE_HOST"
    old_web_dir="$REMOTE_WEB_DIR"
    old_web_server="$WEB_SERVER"

    [[ -n "$new_source" ]] && SOURCE_PATH="$new_source"
    [[ -n "$new_host" ]] && REMOTE_HOST="$new_host"
    [[ -n "$new_web_dir" ]] && REMOTE_WEB_DIR="$new_web_dir"
    [[ -n "$new_web_server" ]] && WEB_SERVER="$new_web_server"

    echo

    read -p "Would you like to run a configuration test before saving? (y/n): " test_choice

    if [[ "$test_choice" =~ ^[Yy]$ ]]; then
        echo -e "\n\e[96mRunning configuration test...\e[0m"
        test_pass=true

        echo -e "\n\e[35mChecking LOCAL directory exists:\e[0m"
        if [[ -d "$SOURCE_PATH" ]]; then
            echo -e "\e[92m✔ Local directory exists: $SOURCE_PATH\e[0m"
		ls $SOURCE_PATH
        else
            echo -e "\e[91m✘ Local directory does not exist!\e[0m"
            test_pass=false
        fi

        echo -e "\n\e[35mChecking SSH connection to REMOTE host ($REMOTE_HOST)...\e[0m"
        if ssh -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_HOST" "echo connected" 2>/dev/null | grep -q connected; then
            echo -e "\e[92m✔ SSH connection to $REMOTE_HOST successful!\e[0m"
        else
            echo -e "\e[93m⚠ SSH connection test failed in batch mode (passphrase required?). Trying again...\e[0m"
            if ssh "$REMOTE_HOST" "echo connected" 2>/dev/null | grep -q connected; then
                echo -e "\e[92m✔ SSH connection to $REMOTE_HOST successful!\e[0m"
            else
                echo -e "\e[91m✘ SSH connection to $REMOTE_HOST failed!\e[0m"
                test_pass=false
            fi
        fi

echo -e "\n\e[35mChecking if REMOTE WEB directory exists ($REMOTE_WEB_DIR)...\e[0m"
if ssh "$REMOTE_HOST" "[[ -d '$REMOTE_WEB_DIR' ]]" 2>/dev/null; then
    echo -e "\e[92m✔ Remote directory exists: $REMOTE_WEB_DIR\e[0m"
    test_pass=true
else
    echo -e "\e[91m✘ Remote directory does not exist!\e[0m"
    test_pass=false
    
    read -p "Would you like to create a new directory? (y/n): " directory_choice
    
    if [[ "$directory_choice" =~ ^[Yy]$ ]]; then
        echo -e "\e[92m Creating directory....\e[0m"
        if ssh "$REMOTE_HOST" "sudo mkdir -p '$REMOTE_WEB_DIR' && sudo chown \$USER:www-data '$REMOTE_WEB_DIR'"; then
            echo -e "\e[92m✔ Directory created successfully.\e[0m"
            test_pass=true
        else
            echo -e "\e[91m✘ Failed to create remote directory!\e[0m"
            test_pass=false
        fi
    else
        echo -e "\e[93mDirectory creation skipped. This may cause issues.\e[0m"
    fi
fi
	  
        echo -e "\n\e[35mChecking if WEB SERVER ($WEB_SERVER) is active...\e[0m"
        if ssh "$REMOTE_HOST" "sudo $WEB_SERVER -t" 2>/dev/null; then
            echo -e "\e[92m✔ $WEB_SERVER configuration test passed.\e[0m"
        else
            echo -e "\e[91m✘ $WEB_SERVER configuration test failed!\e[0m"
            test_pass=false
        fi
	  
        echo

        if $test_pass; then
            echo -e "\e[92m✔ All tests passed. Saving configuration...\e[0m"
        else
            echo -e "\e[91m⚠ Some tests failed!\e[0m"
            read -p "Do you still want to save this configuration anyway? (y/n): " save_choice
            if ! [[ "$save_choice" =~ ^[Yy]$ ]]; then
                echo -e "\e[93mConfiguration NOT saved.\e[0m"
                SOURCE_PATH="$old_source"
                REMOTE_HOST="$old_host"
                REMOTE_WEB_DIR="$old_web_dir"
                WEB_SERVER="$old_web_server"
                return 1
            fi
        fi
    fi

update_or_add_config() {
    local key="$1"
    local value="$2"

    if grep -q "^${key}=" "$CONFIG_FILE"; then
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$CONFIG_FILE"
    else
        echo "${key}=\"${value}\"" >> "$CONFIG_FILE"
    fi
}

# Save or update config variables
update_or_add_config "SOURCE_PATH" "$SOURCE_PATH"
update_or_add_config "REMOTE_HOST" "$REMOTE_HOST"
update_or_add_config "REMOTE_WEB_DIR" "$REMOTE_WEB_DIR"
update_or_add_config "WEB_SERVER" "$WEB_SERVER"


    echo -e "\e[92mConfiguration saved to $CONFIG_FILE\e[0m\n"
        did_save=true
	      read -p "Press Enter to continue..."
		clear
		main_menu
		    echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
		    echo -e "\n\e[1;35mMENU\e[0m\n"
	;;
	
            2)
		main_menu
		run_Manage_Backups "$BACKUP_PATH" "$CONFIG_FILE"
		;;
		
		
            3)
                set_healthcheck
                ;;
		    
            4)
                echo -e "\n\e[93mExiting configuration...\e[0m"
                break
                ;;
            *)
		
		clear 
		main_menu
                echo -e "\e[91mInvalid choice!\e[0m"
		    echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
		    echo -e "\n\e[1;35mMENU\e[0m\n"
                ;;
        esac
    done



    # Export updated variables for current shell
    export SOURCE_PATH REMOTE_HOST REMOTE_WEB_DIR WEB_SERVER BACKUP_PATH
    
    if $did_save; then
        return 0
    else
        return 1
    fi
}



