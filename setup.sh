#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}Kali Arsenal Setup Script${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root (sudo ./setup.sh)${NC}"
  exit 1
fi

# Check if user wants to run the fix scripts first
read -p "Do you want to run the fix scripts before starting installation? (y/n) " run_fix

if [[ $run_fix == "y" || $run_fix == "Y" ]]; then
  echo -e "\n${YELLOW}Running apt fix script...${NC}"
  chmod +x fix-apt.sh
  ./fix-apt.sh
  
  echo -e "\n${YELLOW}Running general fix script...${NC}"
  chmod +x fixbroken.sh
  ./fixbroken.sh
fi

# Update system
echo -e "\n${YELLOW}[+] Updating system packages...${NC}"
apt update
apt install -y python3-apt python3-pip python3-venv

# Install Ansible
echo -e "\n${YELLOW}[+] Installing Ansible...${NC}"
apt install -y ansible ansible-core

# Verify Ansible installation
echo -e "\n${YELLOW}[+] Verifying Ansible installation...${NC}"
ansible --version

# Install required Ansible role
echo -e "\n${YELLOW}[+] Installing required Ansible roles...${NC}"
ansible-galaxy install -r requirements.yml

# Create inventory file if it doesn't exist
if [ ! -f "inventory.ini" ]; then
  echo -e "\n${YELLOW}[+] Creating inventory file...${NC}"
  cat > inventory.ini << 'EOF'
[local]
localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3

[local:vars]
ansible_become=yes
ansible_become_method=sudo
ansible_become_ask_pass=yes
EOF
fi

# Run the playbook
echo -e "\n${YELLOW}[+] Running the Ansible playbook...${NC}"
ansible-playbook -i inventory.ini main.yml

# Check if there were any errors during installation
if [ $? -ne 0 ]; then
  echo -e "\n${RED}[!] There were errors during the installation.${NC}"
  echo -e "${YELLOW}Would you like to run the fix scripts now? (y/n) ${NC}"
  read run_fix_after
  
  if [[ $run_fix_after == "y" || $run_fix_after == "Y" ]]; then
    echo -e "\n${YELLOW}Running apt fix script...${NC}"
    chmod +x fix-apt.sh
    ./fix-apt.sh
    
    echo -e "\n${YELLOW}Running general fix script...${NC}"
    chmod +x fixbroken.sh
    ./fixbroken.sh
    
    echo -e "\n${YELLOW}Trying to run the playbook again...${NC}"
    ansible-playbook -i inventory.ini main.yml
  fi
fi

echo -e "\n${GREEN}[+] Setup complete!${NC}"
echo -e "${BLUE}===============================================${NC}" 