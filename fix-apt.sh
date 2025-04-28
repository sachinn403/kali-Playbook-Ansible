#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}APT Fix Tool for Kali Ansible Playbook${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (use sudo)${NC}"
  exit 1
fi

# Step 1: Clean and update package lists
echo -e "\n${YELLOW}[1/7] Cleaning package lists...${NC}"
apt clean
apt autoclean

# Step 2: Fix any broken dependencies
echo -e "\n${YELLOW}[2/7] Fixing broken dependencies...${NC}"
apt --fix-broken install -y

# Step 3: Configure unconfigured packages
echo -e "\n${YELLOW}[3/7] Configuring unconfigured packages...${NC}"
dpkg --configure -a

# Step 4: Update package lists
echo -e "\n${YELLOW}[4/7] Updating package lists...${NC}"
apt update --fix-missing

# Step 5: Upgrade existing packages
echo -e "\n${YELLOW}[5/7] Upgrading existing packages...${NC}"
apt upgrade -y

# Step 6: Install critical packages
echo -e "\n${YELLOW}[6/7] Installing critical packages...${NC}"
apt install -y python3-apt ansible ansible-core golang golang-go build-essential

# Step 7: Remove unneeded packages
echo -e "\n${YELLOW}[7/7] Removing unnecessary packages...${NC}"
apt autoremove -y

echo -e "\n${GREEN}[✓] APT package manager has been fixed.${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "${YELLOW}Now you can run the Ansible playbook with:${NC}"
echo -e "${GREEN}ansible-playbook -i inventory.ini main.yml${NC}"
echo -e "${BLUE}===============================================${NC}" 