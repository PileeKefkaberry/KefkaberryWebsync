main_menu() {
clear
echo -e "\n\e[92m================================================================"
echo "||     WELCOME TO THE LOCAL → REMOTE WEBSITE TRANSFER SCRIPT     ||"
echo -e "================================================================\e[0m"

echo -e "\e[96mThis script helps you transfer a local website directory to a Remote Device (eg Raspberry Pi)\e[0m"
echo -e "\e[96m||Created by Pilee Kefkaberry @ 8th July 2025 ----- V1.3||\e[0m"
echo
echo -e "\e[96mFEATURES:\e[0m"
echo -e "  \e[35m├\e[0m Syncs your local website folder to the device to update your website via a web server (nginx or apache)"
echo -e "  \e[35m├\e[0m Make backups of the selected folder either locally or remotely"
echo
echo -e "\e[96mREQUIREMENTS:\e[0m"
echo -e "  \e[35m├\e[0m SSH enabled and configured on the remote device."
echo -e "  \e[35m├\e[0m 'rsync' installed on both local and remote devices."
echo -e "  \e[35m├\e[0m Sudo access on the  device to update and reload permissions the web server."
echo
echo -e "================================================================\n"

echo -e "\e[92m=== CURRENT SETTINGS ===\e[0m"
	echo -e "\e[94mLOCAL SOURCE:\e[0m    $SOURCE_PATH"
	echo -e "\e[94mREMOTE HOST:\e[0m     $REMOTE_HOST"
	echo -e "\e[94mREMOTE WEB DIR:\e[0m  $REMOTE_WEB_DIR"
	echo -e "\e[94mWEB SERVER:\e[0m      $WEB_SERVER"
	echo -e "\n\e[92mBACKUP:\e[0m"
	echo -e "\e[94mLOCAL FOLDER:\e[0m    $BACKUP_PATH"
	echo -e "\e[94mREMOTE FOLDER:\e[0m   $REMOTE_BACKUP_PATH on \e[92m($REMOTE_HOST)\e[0m"
	echo

}



























































