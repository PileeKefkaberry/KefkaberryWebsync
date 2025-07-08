# Local2Pi-WebTransfer


## Table of Contents
1. OVERVIEW
2. FEATURES
3. REQUIREMENTS
4. THE CONFIG FILE
5. POTENTIAL ISSUES


 #  OVERVIEW:

This script helps you sync a local website folder to your remote device (eg Raspberry Pi) or another configured linux server.
I made this myself to help me swiftly transfer my local website files to be uploaded to my raspberry pi which uses nginx to upload my website to the world wide web.
As I have developed this over time, this script overall will:
  
  - Synchronise website files from local to remote PCs
  - Create Local and Remote Backups
  - Perform a health check to ensure your website infrastructure is running as intended

In more depth, it will:

- Correctly set required permissions for nginx/apache to function properly when transferring files
- Lets you choose between nginx and apache for your use case
- Lets you choose directly which local directory to send and where to recieve on the remote device

Considering I am relatively new to bash, this script was designed for a new user in mind to provide ease of access visually and interactively. 
However, as this is my first program, this may be a very inefficient way to do the task but it is a personal starting point for me to continue programming and scripting for fun!

On that note, I have taken time to explain here almost everything I can think of so a new user can just read this and learn or feel comfortable with this environment especially when using the terminal. 
I strongly encourage learning and to dissect everything this whole script package offers to learn or to improve. 

# FEATURES:

Features will be described in order as it shows in the main menu:

Start Website Transfer:
├ Syncs your local directory, the folder where your website files are kept (eg /home/user/Documents/Website_Folder)  
├ It will SSH into the device to move this directory to the remote device (eg /home/user/Website_Folder ON REMOTE DEVICE)
├ SSH will then move the folder to the required place for nginx/apache to serve (eg /var/www/html/Wesbite_Folder)
├ File Permissions will be preserved so nginx and apache will function without interupption once the transfer is complete
├ It will restart nginx/apache to recognise the updated directory
├ THIS SCRIPT ASSUMES YOU HAVE SSH AND RSYNC INSTALLED ALONSIDE SUDO ACCESS ON EACH DEVICE!

Run Website Status Check:
├ SSHs into the remote device and begins to perform a website check
├ Website check can be configured in Settings
├ The check involves:
├ Checks if nginx is running on the device 
├ Checks if port 80 and port 443 is open (HTTP + HTTPS)
├ Checks if the public and domain IP match of the device
├ It will ping your website to see if it responds online
├ Checks your SSL Certificates on the device
├ Perform a DNS Lookup for your website
├ Check your UFW status (if configured on the device)
├ Check Disk Space on the device

Every check can be toggled on or off easily in settings to suit your setup as not everyone would want to check disk space or have UFW (Uncomplicated Firewall).

CHECK CONTENTS:

This is just a check that will SSH into the remote device and output the directory contents of your website. This is used to just make sure your site at a glance has the files that you transferred over.

SETTINGS:

Settings is the place where you can easily setup the script to accomodate for your website transfer. This is required on the first instance you run the script otherwise there is no method of transferring directories.

Overall, the settings allow you to:
├ Set the filepath for your local folder to transfer your website
├ Set the SSH hostname so the script can find your remote device
├ Set the filepath of where nginx/apache will serve your website on the remote device
├ Let you choose between using nginx and apache
├ Manage a backup of the website either locally or remotely
├ Set the location of where you want either backup to be
├ Configure the Website check to allow your domain to be used
├ Let you toggle which check to perform:

- nginx (Verifies if the web server is running)
- ports (Confirms ports 80 and 443 are open)
- ip (Checks if public and domain IP match)
- ping (Check if it is possible to connect and get a response from the website)
- ssl (Validates SSL certificate expiry)
- dns (Checks DNS configuration)
- firewall (Checks UFW firewall rules)
- disk (Monitors available storage)

├ Test your configurations before implementing them in case you made a mistake
├ Saves your settings so you don't have to input everything each time

HELP:

This is how you are seeing all of this text. It serves to help you regarding this script and it is an ideal place to document the script so you can learn how it works. 

EXIT:

Simply exit the program!


# REQUIREMENTS:
  - Bash shell (naturally)
  - SSH enabled locally and remotely
  - 'rsync' installed locally and remotely
  - nginx or apache installed on remote device
  - Sudo access for permission management and web server control

# THE CONFIG FILE:

The config file by default is named 'WebsiteTransferConfig.cfg' which stores the settings you have made. You can edit this either via the script or through any text editor of your choice. The file should typically look like:

DOMAIN='www.yourwebsite.com'
STATUS_CHECKS_ENABLED='nginx,ports,ip,ping,ssl,dns,firewall,disk'
SOURCE_PATH='/home/user/Documents/YourWebsite'
REMOTE_HOST='RemoteDevice'
REMOTE_WEB_DIR='/var/www/html/YourWebsite'
WEB_SERVER='nginx'
BACKUP_PATH='/home/user/Documents/YourWebsiteBackups'
REMOTE_BACKUP_PATH='/home/user/YourWebsiteBackups'

Where the variable is on the left and the actual value on the right. Feel free to change the value to your needs.

# POTENTIAL ISSUES/FAQ:

How do I set up the Remote Host like the example above?

Answer: Personally I used a 'host alias' already configured on my local machine and that translated exactly to the script. The example I can give is this:

1. Have SSH Enabled
2. set up the host alias via most commonly 'nano ~/.ssh/config'
3. It may be an empty file, thats okay. Now all that is left for you to do is enter everything in this fashion: 

Host [YourWebsite]
    HostName [192.168.x.xxx]
    User [the username on the remote device]
    Port [the port you have set on the remote device to allow ssh connections]
    IdentityFile ~/.ssh/id_rsaExample (Optional to include this, this is to tell SSH which key to use when logging in, this is more secure but do research on this first
    IdentitiesOnly yes (Optional, this just ensures it will only use the key you specified above to prevent errors and enhances security)

4. This then ensures you just use 'YourWebsite' when inputing the name of the remote device so everything is easier for you visually and interactively.

How do I change more settings,the settings option doesn't include everything I want to change?

Answer: Feel free to edit the scripts! The settings option provides the necessary basics but if you wanted to change up more things such as the text colour or how some things are displayed, feel free to edit the script to your liking. However, be extremely careful as it is always possible to break something but take it as a learning exercise should that happen.

I dont understand what rsync or SSH is and what it does. How do I know more and make changes to my setup with the new knowledge?

Answer: Many online resources are available but the best way to learn it by reading the manual. It contains in depth documentation of each program and how to use it. Example would be:

1. 'man rsync' 
2. A manual in the terminal will be displayed providing as documentation
3. Learn commands through the documentation and perhaps use them in the script should you require to edit them

This sucks

Answer: I know, but so do you.



