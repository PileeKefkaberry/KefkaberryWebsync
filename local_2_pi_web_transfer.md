# Local2Pi-WebTransfer

A simple interactive Bash script to sync local website files to a remote server (e.g., a Raspberry Pi running Nginx or Apache).

---

## 📁 Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Requirements](#requirements)
4. [Configuration](#configuration)
5. [Potential Issues / FAQ](#potential-issues--faq)

---

## 📆 Overview

**Local2Pi-WebTransfer** helps you quickly transfer your website files to a remote Linux device (like a Raspberry Pi) and set up the web server environment correctly.

Originally developed to make personal deployments easier, this script:

- Synchronizes local and remote website directories
- Creates local and remote backups
- Performs a health check on your remote website setup

### ✅ Key Capabilities

- Automatically sets file permissions for Nginx or Apache
- Lets you choose between Nginx and Apache as the web server
- Allows flexible input for local and remote directories
- Designed to be beginner-friendly and interactive
- A great starting point for learning Bash scripting and SSH-based automation

---

## 🚀 Features

### 🔁 Start Website Transfer

- Syncs a local folder to a remote server
- Uses SSH and `rsync` to transfer files securely
- Places the files in the correct server directory (e.g., `/var/www/html`)
- Preserves file permissions so your web server functions immediately
- Restarts Nginx or Apache automatically after the transfer

> ⚠️ Assumes `SSH`, `rsync`, and `sudo` are available on both devices

---

### 📡 Run Website Status Check

- SSH into the remote device and verify server and website status
- Configurable checks include:
  - Nginx/Apache service status
  - Port 80/443 availability
  - Public IP vs domain IP match
  - Website ping test
  - SSL certificate validity
  - DNS resolution
  - UFW firewall status
  - Disk space availability

Each check can be toggled in the **Settings** menu.

---

### 📂 Check Website Contents

- SSH into the remote device and list the contents of the web directory
- Quickly verify that the correct files have been transferred

---

### ⚙️ Settings

First-time setup and configuration are handled here. You can:

- Define the local website folder path
- Set the SSH hostname/alias
- Set the remote web directory path
- Choose between Nginx and Apache
- Configure local or remote backups
- Specify backup paths
- Enable or disable individual status checks
- Test your settings before running operations
- Save settings for future sessions

---

### ❓ Help

This section displays this documentation in the terminal to help you understand how the script works.

---

### 🔚 Exit

Cleanly exit the script.

---

## 📃 Requirements

- Bash shell
- SSH enabled on both local and remote machines
- `rsync` installed on both systems
- Nginx or Apache installed on the remote server
- `sudo` access for managing permissions and restarting web services

---

## 🛠️ Configuration

The script uses a config file (`WebsiteTransferConfig.cfg`) to store your settings. It looks like this:

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

## ❓ Potential Issues / FAQ

### 🔌 How do I set up the remote host?

You can create a simple SSH alias using:

```bash
nano ~/.ssh/config
```

Example:

```ini
Host YourWebsite
    HostName 192.168.x.xxx
    User username
    Port 22
    IdentityFile ~/.ssh/id_rsa  # Optional
    IdentitiesOnly yes          # Optional
```

Now you can simply use `YourWebsite` as the host in the script.

---

### ⚙️ I want to change settings that aren’t in the Settings menu.

You're welcome to edit the script itself! Just be cautious, as incorrect edits may break functionality — but it’s also a great learning opportunity.

---

### ❓ I don’t understand what SSH or `rsync` is. How do I learn more?

Use the terminal manual pages:

```bash
man ssh
man rsync
```

You’ll find detailed usage, examples, and documentation right there.

---

### 💩 This sucks.

I know — but so do you. 😏

