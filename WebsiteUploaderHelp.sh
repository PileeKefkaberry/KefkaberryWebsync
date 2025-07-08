#!/bin/bash

HEADING="\e[93m"
GREEN="\e[92m"
RESET="\e[0m"
BLUE="\e[96m"

echo -e "
${GREEN}===================================================================
${GREEN}                KEFKABERRY WEBSITE TRANSFER SCRIPT HELP
${GREEN}===================================================================

${HEADING}HOW TO EXIT:${RESET}
  - Press 'q' to exit this help.
  - Use arrow keys or Page Up/Down to scroll.

${HEADING}## Table of Contents
${GREEN}1.${RESET} ${BLUE}[OVERVIEW]
${GREEN}2.${RESET} ${BLUE}[FEATURES]
${GREEN}3.${RESET} ${BLUE}[REQUIREMENTS]
${GREEN}4.${RESET} ${BLUE}[THE CONFIG FILE]
${GREEN}5.${RESET} ${BLUE}[POTENTIAL ISSUES/FAQ]

${HEADING}1. OVERVIEW:${RESET}
${BLUE}This script helps you sync a local website folder to your remote device (eg Raspberry Pi) or another configured linux server.
${BLUE}I made this myself to help me swiftly transfer my local website files to be uploaded to my raspberry pi which uses nginx to upload my website to the world wide web.
${BLUE}As I have developed this over time, this script overall will:
  
${BLUE}  - Synchronise website files from local to remote PCs
${BLUE}  - Create Local and Remote Backups
${BLUE}  - Perform a health check to ensure your website infrastructure is running as intended

${GREEN}In more depth, it will:

${BLUE}- Correctly set required permissions for nginx/apache to function properly when transferring files
${BLUE}- Lets you choose between nginx and apache for your use case
${BLUE}- Lets you choose directly which local directory to send and where to recieve on the remote device

${BLUE}Considering I am relatively new to bash, this script was designed for a new user in mind to provide ease of access visually and interactively. 
${BLUE}However, as this is my first program, this may be a very inefficient way to do the task but it is a personal starting point for me to continue programming and scripting for fun!

${BLUE}On that note, I have taken time to explain here almost everything I can think of so a new user can just read this and learn or feel comfortable with this environment especially when using the terminal. 
${BLUE}I strongly encourage learning and to dissect everything this whole script package offers to learn or to improve. 

${HEADING}2. FEATURES:${RESET}

${BLUE}Features will be described in order as it shows in the main menu:

${GREEN}Start Website Transfer:
${BLUE}├ Syncs your local directory, the folder where your website files are kept ${GREEN}(eg /home/user/Documents/Website_Folder)  
${BLUE}├ It will SSH into the device to move this directory to the remote device ${GREEN}(eg /home/user/Website_Folder ON REMOTE DEVICE)
${BLUE}├ SSH will then move the folder to the required place for nginx/apache to serve ${GREEN}(eg /var/www/html/Wesbite_Folder)
${BLUE}├ File Permissions will be preserved so nginx and apache will function without interupption once the transfer is complete
${BLUE}├ It will restart nginx/apache to recognise the updated directory
${BLUE}├ THIS SCRIPT ASSUMES YOU HAVE SSH AND RSYNC INSTALLED ALONSIDE SUDO ACCESS ON EACH DEVICE!

${GREEN}Run Website Status Check:
${BLUE}├ SSHs into the remote device and begins to perform a website check
${BLUE}├ Website check can be configured in Settings
${BLUE}├ The check involves:
${BLUE}├ Checks if nginx is running on the device 
${BLUE}├ Checks if port 80 and port 443 is open (HTTP + HTTPS)
${BLUE}├ Checks if the public and domain IP match of the device
${BLUE}├ It will ping your website to see if it responds online
${BLUE}├ Checks your SSL Certificates on the device
${BLUE}├ Perform a DNS Lookup for your website
${BLUE}├ Check your UFW status (if configured on the device)
${BLUE}├ Check Disk Space on the device

${BLUE}Every check can be toggled on or off easily in settings to suit your setup as not everyone would want to check disk space or have UFW (Uncomplicated Firewall).

${HEADING}CHECK CONTENTS:${RESET}

${BLUE}This is just a check that will SSH into the remote device and output the directory contents of your website. This is used to just make sure your site at a glance has the files that you transferred over.

${HEADING}SETTINGS:${RESET}

${BLUE}Settings is the place where you can easily setup the script to accomodate for your website transfer. This is required on the first instance you run the script otherwise there is no method of transferring directories.

${GREEN}Overall, the settings allow you to:
${BLUE}├ Set the filepath for your local folder to transfer your website
${BLUE}├ Set the SSH hostname so the script can find your remote device
${BLUE}├ Set the filepath of where nginx/apache will serve your website on the remote device
${BLUE}├ Let you choose between using nginx and apache
${BLUE}├ Manage a backup of the website either locally or remotely
${BLUE}├ Set the location of where you want either backup to be
${BLUE}├ Configure the Website check to allow your domain to be used
${BLUE}├ Let you toggle which check to perform:

${BLUE}- nginx (Verifies if the web server is running)
${BLUE}- ports (Confirms ports 80 and 443 are open)
${BLUE}- ip (Checks if public and domain IP match)
${BLUE}- ping (Check if it is possible to connect and get a response from the website)
${BLUE}- ssl (Validates SSL certificate expiry)
${BLUE}- dns (Checks DNS configuration)
${BLUE}- firewall (Checks UFW firewall rules)
${BLUE}- disk (Monitors available storage)

${BLUE}├ Test your configurations before implementing them in case you made a mistake
${BLUE}├ Saves your settings so you don't have to input everything each time

${HEADING}HELP:${RESET}

${BLUE}This is how you are seeing all of this text. It serves to help you regarding this script and it is an ideal place to document the script so you can learn how it works. 

${HEADING}EXIT:${RESET}

${BLUE}Simply exit the program!


${HEADING}3. REQUIREMENTS:${RESET}
  ${BLUE}- Bash shell (naturally)
  ${BLUE}- SSH enabled locally and remotely
  ${BLUE}- 'rsync' installed locally and remotely
  ${BLUE}- nginx or apache installed on remote device
  ${BLUE}- Sudo access for permission management and web server control

${HEADING}4. THE CONFIG FILE:${RESET}

${BLUE}The config file by default is named 'WebsiteTransferConfig.cfg' which stores the settings you have made. You can edit this either via the script or through any text editor of your choice. The file should typically look like:

${BLUE}DOMAIN='www.yourwebsite.com'
${BLUE}STATUS_CHECKS_ENABLED='nginx,ports,ip,ping,ssl,dns,firewall,disk'
${BLUE}SOURCE_PATH='/home/user/Documents/YourWebsite'
${BLUE}REMOTE_HOST='RemoteDevice'
${BLUE}REMOTE_WEB_DIR='/var/www/html/YourWebsite'
${BLUE}WEB_SERVER='nginx'
${BLUE}BACKUP_PATH='/home/user/Documents/YourWebsiteBackups'
${BLUE}REMOTE_BACKUP_PATH='/home/user/YourWebsiteBackups'

${BLUE}Where the variable is on the left and the actual value on the right. Feel free to change the value to your needs.

${HEADING}5. POTENTIAL ISSUES/FAQ:${RESET}

${BLUE}How do I set up the Remote Host like the example above?

${BLUE}Answer: Personally I used a 'host alias' already configured on my local machine and that translated exactly to the script. The example I can give is this:

${BLUE}1. Have SSH Enabled
${BLUE}2. set up the host alias via most commonly 'nano ~/.ssh/config'
${BLUE}3. It may be an empty file, thats okay. Now all that is left for you to do is enter everything in this fashion: 

${BLUE}Host [YourWebsite]
${BLUE}    HostName [192.168.x.xxx]
${BLUE}    User [the username on the remote device]
${BLUE}    Port [the port you have set on the remote device to allow ssh connections]
${BLUE}    IdentityFile ~/.ssh/id_rsaExample (Optional to include this, this is to tell SSH which key to use when logging in, this is more secure but do research on this first
${BLUE}    IdentitiesOnly yes (Optional, this just ensures it will only use the key you specified above to prevent errors and enhances security)

${BLUE}4. This then ensures you just use 'YourWebsite' when inputing the name of the remote device so everything is easier for you visually and interactively.

${BLUE}How do I change more settings,the settings option doesn't include everything I want to change?

${BLUE}Answer: Feel free to edit the scripts! The settings option provides the necessary basics but if you wanted to change up more things such as the text colour or how some things are displayed, feel free to edit the script to your liking. However, be extremely careful as it is always possible to break something but take it as a learning exercise should that happen.

${BLUE}I dont understand what rsync or SSH is and what it does. How do I know more and make changes to my setup with the new knowledge?

${BLUE}Answer: Many online resources are available but the best way to learn it by reading the manual. It contains in depth documentation of each program and how to use it. Example would be:

${BLUE}1. 'man rsync' 
${BLUE}2. A manual in the terminal will be displayed providing as documentation
${BLUE}3. Learn commands through the documentation and perhaps use them in the script should you require to edit them

${BLUE}This sucks

${BLUE}Answer: I know, but so do you.

"

