#!/bin/bash

run_Manage_Backups() {
    BACKUP_PATH="$1"
    CONFIG_FILE="$2"
main_menu

SOURCE_FOLDER_NAME=$(basename "$SOURCE_PATH")

##MAKE NEW VARIABLE TO BE ABLE TO LOCATE REMOTE DIRECTORY THAT ISNT THE WEB DIRECTORY, I MEAN HOME DIRECTORY ON THE DEVICE

    echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    echo -e "\n\e[1;35mMENU > BACKUPS\e[0m\n"
    echo -e "\e[93m  Manage Backups Locally and Remotely\e[0m"
    while true; do
        echo -e " \e[93m 1)\e[0m  Backup Locally"
        echo -e " \e[93m 2)\e[0m  Backup Remotely"
        echo -e " \e[93m 3)\e[0m  Exit"
        
        read -p "Select Setting: [1-3] " setting_choice
        
        case "$setting_choice" in
            1) 
		    	clear
	main_menu
echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
		    echo -e "\n\e[1;35mMENU > BACKUPS > LOCAL\e[0m"
		    echo -e "\n\e[93mThis will create a local backup of your selected folder on your machine.\e[0m\n"
                echo -e "\e[93m 1)\e[0m  Commence Backup" 
                echo -e "\e[93m 2)\e[0m  Set Backup Location"
                echo -e "\e[93m 3)\e[0m  Exit"

                read -p "Select option: [1-3] " local_backup_option
                echo

                case "$local_backup_option" in
                    1)
                        timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

                        if [[ -n "$BACKUP_PATH" ]]; then
                            backup_path="${BACKUP_PATH}/${SOURCE_FOLDER_NAME}_backup_${timestamp}"
                            echo -e "\e[96mCreating backup in configured location: $backup_path...\e[0m"
                        else
                            echo -e "\n\e[91m⚠ No backup location is currently configured!\e[0m"
                            echo -e "\e[93mYou can either:\e[0m"
                            echo -e "1) Set a backup location first (choose option 2)"
                            echo -e "2) Create a temporary backup next to source folder"
                            read -p "Create temporary backup next to source? (y/n): " temp_backup_choice
                        
                            if [[ "$temp_backup_choice" =~ ^[Yy]$ ]]; then
                                backup_path="${SOURCE_PATH}_backup_${timestamp}"
                                echo -e "\e[96mCreating temporary backup at: $backup_path\e[0m"
                            else
                                echo -e "\e[93mBackup canceled. Please configure a backup location first.\e[0m"
                                continue
                            fi
                        fi

                        echo -e "\e[96mCreating backup of $SOURCE_PATH to $backup_path...\e[0m"
                        mkdir -p "$(dirname "$backup_path")"
                        cp -r "$SOURCE_PATH" "$backup_path"

                        if [[ $? -eq 0 ]]; then
                            echo -e "\n\e[92m✔ Backup created successfully at: $backup_path\e[0m\n"
                        else
                            echo -e "\n\e[91m✘ Failed to create backup. (Perhaps Permission issue or random error) \e[0m\n"
                        fi
				    read -p "Press Enter to continue..."
				    clear
				    main_menu
				        echo -e "\n\e[93m--- MANAGE BACKUPS ---\e[0m"
					  echo -e "\e[93mManage Backups Locally and Remotely\e[0m"
                        ;;

                    2)
                        read -p "Enter custom LOCAL backup folder path: [$BACKUP_PATH]: " custom_backup_path
                        custom_backup_path="${custom_backup_path:-$BACKUP_PATH}"

                        while true; do
                            if [[ -z "$custom_backup_path" ]]; then
                                echo -e "\e[91mYou must enter a path.\e[0m"
                                read -p "Enter custom LOCAL backup folder path [$BACKUP_PATH]: " custom_backup_path
                                custom_backup_path="${custom_backup_path:-$BACKUP_PATH}"
                                continue
                            fi

                            if [[ -d "$custom_backup_path" ]]; then
                                break
                            else
                                read -p "Directory doesn't exist. Create it? (y/n): " create_choice
                                if [[ "$create_choice" =~ ^[Yy]$ ]]; then
                                    mkdir -p "$custom_backup_path"
                                    if [[ $? -eq 0 ]]; then
                                        echo -e "\e[92m✔ Created directory: $custom_backup_path\e[0m"
                                        break
                                    else
                                        echo -e "\e[91m✘ Failed to create directory.\e[0m"
                                    fi
                                elif [[ "$create_choice" =~ ^[Nn]$ ]]; then
                                    read -p "Enter a different path or press Enter to cancel: " new_path
                                    if [[ -n "$new_path" ]]; then
                                        custom_backup_path="$new_path"
                                        continue
                                    else
                                        echo -e "\e[93mBackup location configuration canceled.\e[0m"
                                        break
                                    fi
                                else
                                    custom_backup_path="$create_choice"
                                fi
                            fi
                        done

                        if [[ -d "$custom_backup_path" ]]; then
                            timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
                            backup_path="${custom_backup_path}/${SOURCE_FOLDER_NAME}_backup_${timestamp}"

                            echo -e "\e[96mCopying $SOURCE_PATH to $backup_path...\e[0m"
                            cp -r "$SOURCE_PATH" "$backup_path"

                            if [[ $? -eq 0 ]]; then
                                echo -e "\n\e[92m✔ Backup completed successfully.\e[0m\n"
                                
                                if grep -q "^BACKUP_PATH=" "$CONFIG_FILE"; then
                                    sed -i "s|^BACKUP_PATH=.*|BACKUP_PATH=\"$custom_backup_path\"|" "$CONFIG_FILE"
                                else
                                    echo "BACKUP_PATH=\"$custom_backup_path\"" >> "$CONFIG_FILE"
                                fi

                                BACKUP_PATH="$custom_backup_path"
                            else
                                echo -e "\n\e[91m✘ Failed to perform backup.\e[0m\n"
                            fi
                        fi
                        ;;

                    3)
                        clear
				main_menu
					echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    					echo -e "\n\e[1;35mMENU > BACKUPS\e[0m"
					echo -e "\e[93mManage Backups Locally and Remotely\e[0m"
                        ;;

                    *)
                        
				clear 
				main_menu
				    echo -e "\e[91mInvalid option.\e[0m"
				    echo -e "\n\e[1;35mMENU > BACKUPS\e[0m"
				    echo -e "\e[93mManage Backups Locally and Remotely\e[0m"
                        ;;
                esac
                ;;

2)
	clear
	main_menu
echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    echo -e "\n\e[1;35mMENU > BACKUPS > REMOTE\e[0m"
    echo -e "\n\e[93mThis will create a remote backup of your selected folder on your remote device.\e[0m\n"
    echo -e "\e[93m 1)\e[0m  Commence Backup" 
    echo -e "\e[93m 2)\e[0m  Set Backup Location"
    echo -e "\e[93m 3)\e[0m  Exit"

    read -p "Select option: [1-3] " remote_backup_option
    echo

    case "$remote_backup_option" in
1)
    echo -e "\n\e[93mREMOTE BACKUP OPTIONS\e[0m\n"
    echo -e "\e[93m1)\e[0m  Push local folder to remote backup location"
    echo -e "\e[93m2)\e[0m  Make a backup of an existing folder on the remote machine"
    read -p "Choose method: [1-2] " remote_backup_type

    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    SOURCE_FOLDER_NAME=$(basename "$SOURCE_PATH")

    case "$remote_backup_type" in
        1)
            # Push local folder to remote
            if [[ -z "$REMOTE_BACKUP_PATH" ]]; then
                echo -e "\n\e[91m⚠ No remote backup location configured.\e[0m"
                read -p "Create temporary remote backup folder? (y/n): " temp_choice
                if [[ "$temp_choice" =~ ^[Yy]$ ]]; then
                    REMOTE_BACKUP_PATH="~/remote_temp_backups"
                    ssh "$REMOTE_HOST" "mkdir -p \"$REMOTE_BACKUP_PATH\""
                else
                    echo -e "\e[93mCanceled. Please configure a remote backup folder.\e[0m"
                    continue
                fi
            fi

            remote_backup_path="${REMOTE_BACKUP_PATH}/${SOURCE_FOLDER_NAME}_remote_backup_${timestamp}"
            echo -e "\e[96mSyncing local $SOURCE_PATH to $REMOTE_HOST:$remote_backup_path...\e[0m"

            ssh "$REMOTE_HOST" "mkdir -p \"$remote_backup_path\""
            rsync -az --progress "$SOURCE_PATH/" "$REMOTE_HOST:$remote_backup_path/"

            if [[ $? -eq 0 ]]; then
                echo -e "\n\e[92m✔ Remote backup (push) successful to: $remote_backup_path\e[0m\n"
            else
                echo -e "\n\e[91m✘ Remote backup failed.\e[0m\n"
            fi
            read -p "Press Enter to continue..."
            clear
            main_menu
            ;;

        2)
            # Remote folder to remote backup (remote-local copy)
            read -p "Enter full path of folder ON REMOTE to back up: " remote_source_path
            if [[ -z "$remote_source_path" ]]; then
                echo -e "\e[91mNo source folder provided.\e[0m"
                continue
            fi

            remote_source_folder_name=$(basename "$remote_source_path")
            remote_backup_path="${REMOTE_BACKUP_PATH}/${remote_source_folder_name}_remote_backup_${timestamp}"

            echo -e "\e[96mCreating backup of remote folder $remote_source_path to $remote_backup_path...\e[0m"

            ssh "$REMOTE_HOST" "rsync -a --info=progress2 --no-inc-recursive \"$remote_source_path\" \"$remote_backup_path\""

            if [[ $? -eq 0 ]]; then
                echo -e "\n\e[92m✔ Remote-side backup successful.\e[0m\n"
            else
                echo -e "\n\e[91m✘ Remote copy failed. SSH connection may have dropped or cut, or other errors (idk man).\e[0m\n"
            fi
            read -p "Press Enter to continue..."
            clear
            main_menu
            ;;
        *)
            echo -e "\e[91mInvalid option.\e[0m"
		echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
            ;;
    esac
    ;;


        2)
            echo -e "\e[96mEnter the remote directory path on $REMOTE_HOST where backups should be saved.\e[0m"
            read -p "Remote backup directory [$REMOTE_BACKUP_PATH]: " remote_path_input
            remote_path_input="${remote_path_input:-$REMOTE_BACKUP_PATH}"

            while true; do
                if [[ -z "$remote_path_input" ]]; then
                    echo -e "\e[91mYou must enter a path.\e[0m"
                    read -p "Remote backup directory [$REMOTE_BACKUP_PATH]: " remote_path_input
                    remote_path_input="${remote_path_input:-$REMOTE_BACKUP_PATH}"
                    continue
                fi

                if ssh "$REMOTE_HOST" "[ -d \"$remote_path_input\" ]"; then
                    echo -e "\e[92m✔ Remote directory exists: $remote_path_input\e[0m"
                    break
                else
                    read -p "Directory does not exist. Create it on remote host? (y/n): " create_remote_dir
                    if [[ "$create_remote_dir" =~ ^[Yy]$ ]]; then
                        ssh "$REMOTE_HOST" "mkdir -p \"$remote_path_input\""
                        if [[ $? -eq 0 ]]; then
                            echo -e "\e[92m✔ Created remote directory: $remote_path_input\e[0m"
                            break
                        else
                            echo -e "\e[91m✘ Failed to create remote directory. Check permissions or SSH.\e[0m"
                        fi
                    elif [[ "$create_remote_dir" =~ ^[Nn]$ ]]; then
                        read -p "Enter a different remote path or press Enter to cancel: " new_remote_path
                        if [[ -n "$new_remote_path" ]]; then
                            remote_path_input="$new_remote_path"
                            continue
                        else
                            echo -e "\e[93mRemote backup location configuration canceled.\e[0m"
                            break
                        fi
                    fi
                fi
            done

            if [[ -n "$remote_path_input" && "$(ssh "$REMOTE_HOST" "[ -d \"$remote_path_input\" ] && echo exists")" == "exists" ]]; then
                REMOTE_BACKUP_PATH="$remote_path_input"
                
                if grep -q "^REMOTE_BACKUP_PATH=" "$CONFIG_FILE"; then
                    sed -i "s|^REMOTE_BACKUP_PATH=.*|REMOTE_BACKUP_PATH=\"$REMOTE_BACKUP_PATH\"|" "$CONFIG_FILE"
                else
                    echo "REMOTE_BACKUP_PATH=\"$REMOTE_BACKUP_PATH\"" >> "$CONFIG_FILE"
                fi

                echo -e "\e[92m✔ Remote backup path saved to config.\e[0m"
            fi
            read -p "Press Enter to continue..."
            clear
            main_menu
            ;;

        3)
            clear
            main_menu
            echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    		echo -e "\n\e[1;35mMENU > BACKUPS\e[0m"
            echo -e "\e[93mManage Backups Locally and Remotely\e[0m"
            ;;

        *)
            clear
            echo -e "\e[91mInvalid option.\e[0m"
		echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
            ;;
    esac
    ;;


            3)
                clear 
		    main_menu
		    		echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
				echo -e "\n\e[1;35mMENU\e[0m"
                break
                ;;
            
            *)
		    	clear 
			main_menu
				echo -e "\e[91mInvalid choice!\e[0m"
				echo -e "\n \e[93m=========== SETTINGS ===========\e[0m"
    				echo -e "\n\e[1;35mMENU > BACKUPS\e[0m\n"
				echo -e "\e[93mManage Backups Locally and Remotely\e[0m"
                ;;
        esac
    done
}