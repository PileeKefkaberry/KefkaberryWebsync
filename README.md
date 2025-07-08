# KefkaberryWebsync

A simple interactive Bash script to sync local website files to a remote server (e.g., a Raspberry Pi running Nginx or Apache).

---

## 📁 Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Requirements](#requirements)
4. [The Config File](#The-config-file)
5. [Potential Issues / FAQ](#potential-issues--faq)

---

##  Overview

**KefkaberryWebsync** helps you quickly transfer your website files to a remote Linux device (like a Raspberry Pi) and set up the web server environment correctly.
I made this myself to help me swiftly transfer my local website files to be uploaded to my raspberry pi which uses nginx to upload my website to the world wide web.
As I have developed this over time, this script overall will:

- Synchronize local and remote website directories
- Creates local and remote backups
- Performs a health check on your remote website setup

### Key Capabilities

- Automatically sets file permissions for Nginx or Apache
- Lets you choose between Nginx and Apache as the web server
- Allows flexible input for local and remote directories
- Designed to be beginner-friendly and interactive

Considering I am relatively new to bash, this script was designed for a new user in mind to provide ease of access visually and interactively. 
However, as this is my first program, this may be a very inefficient way to do the task but it is a personal starting point for me to continue programming and scripting for fun!
On that note, I have taken time to explain here almost everything I can think of so a new user can just read this and learn or feel comfortable with this environment especially when using the terminal. 
I strongly encourage learning and to dissect everything this whole script package offers to learn or to improve. 

---

##  Features

Features will be described in order as it shows in the main menu:

### 1. Start Website Transfer

├ Syncs your local directory, the folder where your website files are kept ${GREEN}(eg `/home/user/Documents/Website_Folder`)  
├ It will SSH into the device to move this directory to the remote device ${GREEN}(eg `/home/user/Website_Folder` ON REMOTE DEVICE)
├ SSH will then move the folder to the required place for nginx/apache to serve ${GREEN}(eg `var/www/html/Wesbite_Folder`)
├ File Permissions will be preserved so nginx and apache will function without interupption once the transfer is complete
├ It will restart nginx/apache to recognise the updated directory

> ⚠️ Assumes `SSH`, `rsync`, and `sudo` are available on both devices

---

### 2. Run Website Status Check

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

---

### 3. Check Website Contents

This is just a check that will SSH into the remote device and output the directory contents of your website. 
This is used to just make sure your site at a glance has the files that you transferred over.

---

### 4. Settings

Settings is the place where you can easily setup the script to accomodate for your website transfer. This is required on the first instance you run the script otherwise there is no method of transferring directories.

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

---

### ❓ Help

This section displays this documentation in the terminal to help you understand how the script works.

---

###  Exit

Cleanly exit the script.

---

##  Requirements

- Bash shell
- SSH enabled on both local and remote machines
- `rsync` installed on both systems
- Nginx or Apache installed on the remote server
- `sudo` access for managing permissions and restarting web services

---

## 5. The Config File

The config file by default is named `WebsiteTransferConfig.cfg` which stores the settings you have made. You can edit this either via the script or through any text editor of your choice. The file should typically look like:

```ini
DOMAIN='www.yourwebsite.com'
STATUS_CHECKS_ENABLED='nginx,ports,ip,ping,ssl,dns,firewall,disk'
SOURCE_PATH='/home/user/Documents/YourWebsite'
REMOTE_HOST='RemoteDevice'
REMOTE_WEB_DIR='/var/www/html/YourWebsite'
WEB_SERVER='nginx'
BACKUP_PATH='/home/user/Documents/YourWebsiteBackups'
REMOTE_BACKUP_PATH='/home/user/YourWebsiteBackups'
```

Edit this file directly or use the **Settings** menu in the script.

---

## 6. Potential Issues / FAQ

###  How do I set up the remote host?

Personally I used a 'host alias' already configured on my local machine and that translated exactly to the script. The example I can give is this:

```bash
nano ~/.ssh/config
```

It may be an empty file, thats okay. Now all that is left for you to do is enter everything in this fashion:

```ini
Host YourWebsite
    HostName 192.168.x.xxx
    User username
    Port 22
    IdentityFile ~/.ssh/id_rsa  # Optional (this is to tell SSH which key to use when logging in, this is more secure but do research on this first)
    IdentitiesOnly yes          # Optional (this just ensures it will only use the key you specified above to prevent errors and enhances security)
```

This then ensures you just use 'YourWebsite' when inputing the name of the remote device so everything is easier for you visually and interactively.

---

###  I want to change settings that aren’t in the Settings menu.

You're welcome to edit the script itself! Just be cautious, as incorrect edits may break functionality — but it’s also a great learning opportunity.

---

###  I don’t understand what SSH or `rsync` is. How do I learn more?
Many online resources are available but the best way to learn it by reading the manual. It contains in depth documentation of each program and how to use it. 

Use the terminal manual pages:

```bash
man ssh
man rsync
```

Learn commands through the documentation and perhaps use them in the script should you require to edit them.

---

###  This sucks.

I know — but so do you. 😏

## Credits

Created by: Pilee Kefkaberry
Date: 8 July 2025
License: GNU v3.0
