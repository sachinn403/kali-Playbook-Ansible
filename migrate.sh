#!/bin/bash

# Kali Ansible Playbook Migration Script
# This script helps migrate the existing project structure to follow Ansible best practices

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Kali Ansible Playbook Migration Script ===${NC}"
echo -e "${YELLOW}This script will reorganize your project to follow Ansible best practices${NC}"
echo -e "${YELLOW}Make sure you have a backup before proceeding${NC}"
echo ""

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in mkdir cp mv; do
  if ! command_exists $cmd; then
    echo -e "${RED}Error: Required command '$cmd' not found.${NC}"
    exit 1
  fi
done

# Create the directory structure if it doesn't exist already
echo -e "${BLUE}Creating directory structure...${NC}"
mkdir -p inventory/group_vars/all
mkdir -p inventory/host_vars
mkdir -p playbooks
mkdir -p logs

# Move existing inventory file
if [ -f inventory.ini ]; then
  echo -e "${GREEN}Moving inventory.ini to inventory/hosts.ini${NC}"
  cp inventory.ini inventory/hosts.ini
fi

# Move main playbook
if [ -f main.yml ]; then
  echo -e "${GREEN}Moving main.yml to playbooks/main.yml${NC}"
  cp main.yml playbooks/main.yml
fi

# Create individual playbooks if they don't exist
for playbook in install-tools configure-system customize-terminal customize-browser configure-logging configure-tmux; do
  if [ ! -f "playbooks/${playbook}.yml" ]; then
    echo -e "${GREEN}Creating playbooks/${playbook}.yml${NC}"
    cat > "playbooks/${playbook}.yml" << EOF
---
# Playbook for ${playbook//-/ }
- name: "${playbook//-/ | sed 's/\b\(.\)/\u\1/g'}"
  hosts: all
  become: true
  become_method: sudo
  gather_facts: true
  
  tasks:
    - name: "${playbook//-/ | sed 's/\b\(.\)/\u\1/g'}"
      include_role:
        name: ${playbook}
      tags:
        - ${playbook}
EOF
  fi
done

# Create ansible.cfg if it doesn't exist
if [ ! -f ansible.cfg ]; then
  echo -e "${GREEN}Creating ansible.cfg${NC}"
  cat > ansible.cfg << EOF
[defaults]
inventory = inventory/hosts.ini
roles_path = roles
library = library
module_utils = module_utils
remote_tmp = ~/.ansible/tmp
local_tmp = ~/.ansible/tmp
forks = 10
poll_interval = 15
sudo_user = root
transport = smart
remote_port = 22
timeout = 60
host_key_checking = False
log_path = logs/ansible.log
nocows = 1
interpreter_python = auto_silent
deprecation_warnings = True
command_warnings = True
system_warnings = True
display_skipped_hosts = True
error_on_undefined_vars = True
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = .ansible_cache
fact_caching_timeout = 86400
stdout_callback = yaml
callback_whitelist = timer, profile_tasks, profile_roles
bin_ansible_callbacks = True
force_handlers = True

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
control_path = %(directory)s/ansible-ssh-%%h-%%p-%%r
pipelining = True
scp_if_ssh = True

[paramiko_connection]
record_host_keys = False

[diff]
always = yes
context = 3
EOF
fi

# Create run-playbook script
if [ ! -f run-playbook.sh ] || [ -f run-playbook.sh -a "$(grep -c 'inventory/hosts.ini' run-playbook.sh)" -eq 0 ]; then
  echo -e "${GREEN}Creating run-playbook.sh${NC}"
  cat > run-playbook.sh << EOF
#!/bin/bash

# Create logs directory if it doesn't exist
mkdir -p logs

# Run the Ansible playbook with proper options
ansible-playbook -i inventory/hosts.ini playbooks/main.yml --ask-become-pass "\$@"

# Display completion message
echo -e "\n\nPlaybook execution completed. Check logs/ansible.log for details."
EOF
  chmod +x run-playbook.sh
fi

# Create or update group_vars/all/main.yml
if [ ! -f inventory/group_vars/all/main.yml ]; then
  echo -e "${GREEN}Creating inventory/group_vars/all/main.yml${NC}"
  cat > inventory/group_vars/all/main.yml << EOF
---
# Common variables for all hosts

# General configuration
kali_mode: true  # Set to true for Kali Linux systems
enable_logging: true  # Enable advanced logging
configure_tmux: true  # Configure tmux
customize_terminal: true  # Customize terminal appearance
customize_browser: true  # Customize browser settings

# Tool installation options
install_tools: true  # Master toggle for tool installation
skip_duplicate_check: false  # Skip checking for duplicate tools

# Specific tool installation flags
skip_nuclei: false  # Skip nuclei installation if already present
skip_httpx: false  # Skip httpx installation if already present
skip_ffuf: false  # Skip ffuf installation if already present
skip_bloodhound: false  # Skip BloodHound installation if already present

# Visual Studio Code configuration
install_vscode: true  # Install Visual Studio Code
vscode_extensions:
  - streetsidesoftware.code-spell-checker
  - ms-python.python
  - DEVSENSE.phptools-vscode
  - GitHub.copilot
  - snyk-security.snyk-vulnerability-scanner

# System configuration
configure_system: true  # Configure system settings
system_hostname: "kali-pentest"  # Default hostname (can be overridden in host_vars)
timezone: "UTC"  # Default timezone

# Custom paths
tools_base_path: /opt  # Base path for tool installation
EOF
fi

# Update requirements.yml
echo -e "${GREEN}Updating requirements.yml${NC}"
cat > requirements.yml << EOF
---
# External role dependencies
roles:
  - name: gantsign.visual-studio-code
    version: 6.7.0  # Use a specific version for stability

collections:
  - name: community.general
    version: 7.0.0
  - name: ansible.posix
    version: 1.5.1
EOF

echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}Migration completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the generated files and customize as needed"
echo "2. Run the updated playbook with: ./run-playbook.sh"
echo "3. Check logs/ansible.log for execution details"
echo -e "${BLUE}======================================${NC}" 