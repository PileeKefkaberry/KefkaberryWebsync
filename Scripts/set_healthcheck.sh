set_healthcheck() {
    # Load existing health check config from main config file
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
    
source "$SCRIPT_DIR/Scripts/configure_settings.sh"
    
update_or_add_config() {
    local key="$1"
    local value="$2"

    if grep -q "^${key}=" "$CONFIG_FILE"; then
        sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$CONFIG_FILE"
    else
        echo "${key}=\"${value}\"" >> "$CONFIG_FILE"
    fi
}
    
    # Set defaults
    DOMAIN=${DOMAIN:-""}
    STATUS_CHECKS_ENABLED=${STATUS_CHECKS_ENABLED:-"nginx,ports,ip,ping,ssl,dns,firewall,disk"}
    
    while true; do
        clear
        main_menu
	  
        echo -e "\n \e[93m==== Website Status Check Configuration ====\e[0m"
        echo -e "\nCurrent settings:"
	
	  # Define all possible checks
ALL_CHECKS=("nginx" "ports" "ip" "ping" "ssl" "dns" "firewall" "disk")


IFS=',' read -ra ENABLED <<< "$STATUS_CHECKS_ENABLED"

echo

# Header
printf "\e[1m%-12s | %-8s\e[0m\n" "Check" "Status"
printf "%s\n" "-------------+----------"
printf "%-12s | \e[92m%s\e[0m\n" "Domain" "$DOMAIN"

# Loop through all checks
for check in "${ALL_CHECKS[@]}"; do
    if [[ " ${ENABLED[@]} " =~ " $check " ]]; then
        printf "%-12s | \e[92m✔\e[0m\n" "$check"
    else
        printf "%-12s | \e[91m✘\e[0m\n" "$check"
    fi
done

        echo -e "\n\e[96mWhat would you like to configure?\e[0m"
        echo -e "\e[93m 1)\e[0m Edit domain"
        echo -e "\e[93m 2)\e[0m Toggle checks to perform"
        echo -e "\e[93m 3)\e[0m Test current configuration"
        echo -e "\e[93m 4)\e[0m Save and exit"
        
        read -p "Select option: [1-4] " hc_choice
        
        case "$hc_choice" in
            1)
                read -p "Enter the domain name to check (e.g., www.example.com): " new_domain
                if [[ -n "$new_domain" ]]; then
                    DOMAIN="$new_domain"
                    echo -e "\e[92mDomain updated to: $DOMAIN\e[0m"
                fi
                ;;
                
            2)
                echo -e "\n\e[96mEnable or disable each check below (y/n):\e[0m"
                

                ALL_CHECKS=("nginx" "ports" "ip" "ping" "ssl" "dns" "firewall" "disk")
                ENABLED_CHECKS=()


                IFS=',' read -ra CURRENT_ENABLED <<< "$STATUS_CHECKS_ENABLED"

                for check in "${ALL_CHECKS[@]}"; do
                    # Default to current state (enabled/disabled)
                    if [[ " ${CURRENT_ENABLED[@]} " =~ " $check " ]]; then
                        default="y"
                    else
                        default="n"
                    fi

                    # Ask user
                    read -p "Enable $check? [y/n] (default: $default): " response
                    response=${response,,}  

                    if [[ -z "$response" ]]; then
                        response="$default"
                    fi

                    if [[ "$response" == "y" ]]; then
                        ENABLED_CHECKS+=("$check")
                    fi
                done


                STATUS_CHECKS_ENABLED=$(IFS=','; echo "${ENABLED_CHECKS[*]}")
                echo -e "\e[92mEnabled checks updated: $STATUS_CHECKS_ENABLED\e[0m"

                ;;
                
            3)
                echo -e "\n\e[96mRunning health check with current settings...\e[0m"
                    ssh "$REMOTE_HOST" "
        			export DOMAIN='$DOMAIN'
        			export STATUS_CHECKS_ENABLED='$STATUS_CHECKS_ENABLED'
        			bash -s" < "$SCRIPT_DIR/Website_Status_Check.sh"
                ;;
                
            4)
                # Save configuration to main config file
                update_or_add_config "DOMAIN" "$DOMAIN"
                update_or_add_config "STATUS_CHECKS_ENABLED" "$STATUS_CHECKS_ENABLED"
                echo -e "\e[92mHealth check configuration saved to $CONFIG_FILE\e[0m"
		    		    	echo -e "\n\e[93mPress Enter to return to the main menu...\e[0m"
	read
	clear 
	main_menu
                return 0

                ;;
                
            *)
                echo -e "\e[91mInvalid option!\e[0m"
                ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}
