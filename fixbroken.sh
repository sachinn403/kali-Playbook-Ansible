#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}Kali Ansible Playbook Fix Tool${NC}"
echo -e "${BLUE}===============================================${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (use sudo)${NC}"
  exit 1
fi

# Fix apt issues
echo -e "\n${YELLOW}[+] Fixing package management system...${NC}"
apt clean
apt update --fix-missing
dpkg --configure -a
apt install -f -y
apt autoremove -y

# Fix common Ansible issues
echo -e "\n${YELLOW}[+] Installing/fixing Python dependencies...${NC}"
apt update
apt install -y python3-apt python3-pip python3-venv ansible ansible-core

# Manually install common tools that might fail with ansible
echo -e "\n${YELLOW}[+] Installing common tools via apt...${NC}"
apt install -y pipx gh flameshot docker.io docker-compose bloodhound build-essential

# Fix Go installation issues
echo -e "\n${YELLOW}[+] Fixing Go installation...${NC}"
apt install -y golang golang-go

# Ensure the docker service is running
echo -e "\n${YELLOW}[+] Ensuring Docker service is running...${NC}"
systemctl enable docker --now || true
usermod -aG docker $USER || true

# Set up Go environment
echo -e "\n${YELLOW}[+] Setting up Go environment...${NC}"
mkdir -p /root/go/{bin,pkg,src}
echo 'export GOPATH=$HOME/go' >> /root/.bashrc
echo 'export PATH=$PATH:/usr/bin/go:/usr/local/go/bin:$GOPATH/bin' >> /root/.bashrc

# Fix broken repositories
echo -e "\n${YELLOW}[+] Fixing broken repositories...${NC}"

# Create base directories
mkdir -p /opt/ActiveDirectory /opt/web /opt/cloud /opt/c2 /opt/utilities /opt/windows-binaries /opt/mobile /opt/iot

# Fix ADCSKiller repository
echo -e "${GREEN}    Fixing ADCSKiller repository...${NC}"
if [ -d "/opt/ActiveDirectory/adcskiller" ]; then
  rm -rf /opt/ActiveDirectory/adcskiller
fi
mkdir -p /opt/ActiveDirectory/adcskiller
git clone https://github.com/p0dalirius/ADCSKiller /opt/ActiveDirectory/adcskiller

# Fix other common broken repositories
declare -A repo_fixes=(
  ["BloodHound"]="https://github.com/BloodHoundAD/BloodHound"
  ["CrackMapExec"]="https://github.com/Porchetta-Industries/CrackMapExec"
  ["nuclei"]="https://github.com/projectdiscovery/nuclei"
  ["subfinder"]="https://github.com/projectdiscovery/subfinder"
  ["httpx"]="https://github.com/projectdiscovery/httpx"
  ["naabu"]="https://github.com/projectdiscovery/naabu"
)

for tool in "${!repo_fixes[@]}"; do
  repo_url="${repo_fixes[$tool]}"
  destination="/opt/ActiveDirectory/$tool"
  
  if [[ "$tool" == "nuclei" || "$tool" == "subfinder" || "$tool" == "httpx" || "$tool" == "naabu" ]]; then
    destination="/opt/web/$tool"
  fi
  
  echo -e "${GREEN}    Fixing $tool repository...${NC}"
  if [ -d "$destination" ]; then
    rm -rf "$destination"
  fi
  mkdir -p "$destination"
  git clone "$repo_url" "$destination" || echo -e "${RED}    Failed to clone $tool${NC}"
done

# Fix Go tools
echo -e "\n${YELLOW}[+] Installing key Go tools manually...${NC}"
export GOPATH=$HOME/go
export PATH=$PATH:/usr/bin/go:/usr/local/go/bin:$GOPATH/bin

go_tools=(
  "github.com/ffuf/ffuf@latest"
  "github.com/OJ/gobuster/v3/cmd/gobuster@latest"
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
  "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
  "github.com/projectdiscovery/httpx/cmd/httpx@latest"
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
)

for tool in "${go_tools[@]}"; do
  echo -e "${GREEN}    Installing $tool...${NC}"
  go install -v $tool || echo -e "${RED}    Failed to install $tool${NC}"
done

# Create necessary symlinks
echo -e "\n${YELLOW}[+] Creating necessary symlinks...${NC}"
ln -sf $HOME/go/bin/nuclei /usr/local/bin/nuclei
ln -sf $HOME/go/bin/httpx /usr/local/bin/httpx
ln -sf $HOME/go/bin/subfinder /usr/local/bin/subfinder
ln -sf $HOME/go/bin/naabu /usr/local/bin/naabu
ln -sf $HOME/go/bin/ffuf /usr/local/bin/ffuf
ln -sf $HOME/go/bin/gobuster /usr/local/bin/gobuster

# Create a simple restart script
echo -e "\n${YELLOW}[+] Creating restart script...${NC}"
cat > /usr/local/bin/restart-ansible-playbook << 'EOF'
#!/bin/bash
cd ~/Desktop/kali-Playbook-Ansible
sudo ansible-playbook -i inventory.ini main.yml
EOF
chmod +x /usr/local/bin/restart-ansible-playbook

echo -e "\n${GREEN}[✓] Fixes applied. You can now try running the Ansible playbook again.${NC}"
echo -e "${GREEN}    Or use the 'restart-ansible-playbook' command.${NC}"
echo -e "${BLUE}===============================================${NC}" 