#!/bin/bash
# Run-playbook.sh - Helper script to run Ansible playbooks

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
PLAYBOOK="playbooks/main.yml"
INVENTORY="inventory/hosts.ini"
TAGS=""
SKIP_TAGS=""
VERBOSE=""
ASK_SUDO_PASS="-K"
LOG_FILE="ansible-playbook.log"

# Display help message
function display_help {
    echo -e "${GREEN}Kali Linux Ansible Playbook Runner${NC}"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help                  Display this help message"
    echo "  -p, --playbook PLAYBOOK     Specify the playbook to run (default: playbooks/main.yml)"
    echo "  -i, --inventory INVENTORY   Specify the inventory file (default: inventory/hosts.ini)"
    echo "  -t, --tags TAGS             Only run plays and tasks tagged with these values"
    echo "  -s, --skip-tags TAGS        Skip plays and tasks tagged with these values"
    echo "  -v, --verbose               Increase verbosity (use -vvv for max verbosity)"
    echo "  --no-sudo-pass              Don't ask for sudo password"
    echo "  --log FILE                  Log output to specified file (default: ansible-playbook.log)"
    echo ""
    echo "Examples:"
    echo "  $0                          # Run the main playbook with default options"
    echo "  $0 --tags 'tools'           # Only install tools"
    echo "  $0 --tags 'github-releases' # Only run github-releases tasks"
    echo "  $0 --skip-tags 'browser'    # Skip browser configuration"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            display_help
            exit 0
            ;;
        -p|--playbook)
            PLAYBOOK="$2"
            shift
            shift
            ;;
        -i|--inventory)
            INVENTORY="$2"
            shift
            shift
            ;;
        -t|--tags)
            TAGS="--tags $2"
            shift
            shift
            ;;
        -s|--skip-tags)
            SKIP_TAGS="--skip-tags $2"
            shift
            shift
            ;;
        -v|--verbose)
            VERBOSE="-v"
            shift
            ;;
        -vv)
            VERBOSE="-vv"
            shift
            ;;
        -vvv)
            VERBOSE="-vvv"
            shift
            ;;
        --no-sudo-pass)
            ASK_SUDO_PASS=""
            shift
            ;;
        --log)
            LOG_FILE="$2"
            shift
            shift
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            display_help
            exit 1
            ;;
    esac
done

# Check if playbook exists
if [ ! -f "$PLAYBOOK" ]; then
    echo -e "${RED}Error: Playbook $PLAYBOOK not found${NC}"
    exit 1
fi

# Check if inventory exists
if [ ! -f "$INVENTORY" ]; then
    echo -e "${RED}Error: Inventory $INVENTORY not found${NC}"
    exit 1
fi

# Warn if running without sudo password
if [ -z "$ASK_SUDO_PASS" ]; then
    echo -e "${YELLOW}Warning: Running without asking for sudo password${NC}"
fi

# Prepare command
COMMAND="ansible-playbook $PLAYBOOK -i $INVENTORY $TAGS $SKIP_TAGS $VERBOSE $ASK_SUDO_PASS"

# Display command to be executed
echo -e "${GREEN}Executing:${NC} $COMMAND"
echo -e "${GREEN}Logging to:${NC} $LOG_FILE"
echo ""
echo -e "${YELLOW}Starting playbook execution...${NC}"
echo ""

# Execute the command and log the output
$COMMAND 2>&1 | tee "$LOG_FILE"

# Check the exit status
exit_status=${PIPESTATUS[0]}
if [ $exit_status -eq 0 ]; then
    echo ""
    echo -e "${GREEN}Playbook execution completed successfully!${NC}"
else
    echo ""
    echo -e "${RED}Playbook execution failed with exit status $exit_status${NC}"
    echo -e "${YELLOW}Check $LOG_FILE for more details${NC}"
fi

exit $exit_status 