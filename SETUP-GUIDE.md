# Kali Linux Penetration Testing Setup Guide

This guide helps you set up a Kali Linux environment optimized for penetration testing with our Ansible playbook.

## What's Fixed

The setup has been improved to fix these common issues:

1. **Sudo Password Issues**: Now properly handles sudo password prompts
2. **Missing Dependencies**: Installs python3-apt and other required dependencies
3. **Duplicate Tool Installations**: Prevents duplicate installations of tools
4. **Go Environment**: Properly sets up Go and installs security tools

## Installation Options

### Option 1: Quick Setup (Recommended)

1. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

2. Run the script with sudo:
   ```bash
   sudo ./setup.sh
   ```

This will:
- Ask if you want to run fix scripts first (recommended)
- Install necessary dependencies
- Set up Ansible
- Install required roles
- Run the playbook with the correct options
- Automatically run fix scripts if errors occur

### Option 2: Manual Setup

If you prefer to run commands manually:

1. Install prerequisites:
   ```bash
   sudo apt update
   sudo apt install -y python3-apt python3-pip ansible ansible-core
   ```

2. Install required Ansible roles:
   ```bash
   ansible-galaxy install -r requirements.yml
   ```

3. Run the playbook:
   ```bash
   ansible-playbook -i inventory.ini main.yml
   ```

## What Gets Installed

- **Essential Tools**: Git, curl, docker, build-essential
- **Go Environment**: Go programming language with security tools
- **Security Tools**: 
  - Web: ffuf, nuclei, httpx, katana
  - ActiveDirectory: Bloodhound, CrackMapExec
  - Network: nmap, naabu, masscan
  - And more...

## Using the Environment

After installation:

1. Source your profile to get Go in your path:
   ```bash
   source ~/.bashrc
   ```

2. Verify tool installations:
   ```bash
   which nuclei httpx ffuf
   ```

## Troubleshooting

If you encounter issues:

1. First, try the specialized fix scripts:
   ```bash
   # Fix APT-related issues
   sudo ./fix-apt.sh
   
   # Fix general installation issues (repositories, tools, etc.)
   sudo ./fixbroken.sh
   ```

2. Common issues and fixes:
   - **APT errors**: Use `sudo ./fix-apt.sh` to repair package management system
   - **Repository errors**: Use `sudo ./fixbroken.sh` to fix broken repos like ADCSKiller
   - **Go tool failures**: The fixbroken.sh script will install Go tools manually
   - **Missing symlinks**: The fixbroken.sh script creates necessary symlinks

### Fixing Common Errors

If you see errors about broken repositories, missing tools, or installation failures, use the provided fix scripts:

```bash
# Fix APT issues first
chmod +x fix-apt.sh
sudo ./fix-apt.sh

# Then fix other issues
chmod +x fixbroken.sh
sudo ./fixbroken.sh
```

The fix-apt.sh script will:
- Clean your APT cache
- Fix broken dependencies
- Update package lists
- Install critical packages

The fixbroken.sh script will:
- Fix broken repository links (including ADCSKiller)
- Properly set up Go environment
- Install key tools that might have failed
- Create necessary symlinks

### Manual Fixes

If specific tools are failing to install:

1. For Go tools: 
   ```bash
   sudo apt install -y golang-go
   export GOPATH=$HOME/go
   export PATH=$PATH:/usr/bin/go:/usr/local/go/bin:$GOPATH/bin
   go install -v github.com/toolname/tool@latest
   ```

2. For broken repositories:
   ```bash
   sudo rm -rf /opt/category/broken-tool
   sudo git clone https://github.com/author/correct-repo /opt/category/broken-tool
   ```

For more details, check the README.md file. 