# Kali Arsenal: The Ultimate Security Toolkit

<p align="center">
  <img src="https://www.kali.org/images/kali-dragon-icon.svg" alt="Kali Linux Logo" width="150" height="150">
</p>

<p align="center">
  <a href="https://github.com/sachinn403/kali-Playbook-Ansible/stargazers"><img src="https://img.shields.io/github/stars/sachinn403/kali-Playbook-Ansible?style=flat-square" alt="Stars Badge"/></a>
  <a href="https://github.com/sachinn403/kali-Playbook-Ansible/network/members"><img src="https://img.shields.io/github/forks/sachinn403/kali-Playbook-Ansible?style=flat-square" alt="Forks Badge"/></a>
  <a href="https://github.com/sachinn403/kali-Playbook-Ansible/blob/main/LICENSE"><img src="https://img.shields.io/github/license/sachinn403/kali-Playbook-Ansible?style=flat-square" alt="License Badge"/></a>
  <a href="https://www.ansible.com/"><img src="https://img.shields.io/badge/Automation-Ansible-red?style=flat-square" alt="Ansible Badge"/></a>
  <a href="https://www.kali.org/"><img src="https://img.shields.io/badge/Platform-Kali%20Linux-blue?style=flat-square" alt="Kali Linux Badge"/></a>
</p>

An enterprise-ready, fully automated Ansible playbook for deploying a comprehensive security testing environment on Kali Linux. This playbook installs, organizes, and configures all essential penetration testing tools with a structured approach designed for professional security assessments.

## 📑 Table of Contents
- [Quick Start](#-quick-start)
- [Key Features](#-key-features)
- [Tool Categories](#-tool-categories)
- [Installation Options](#-installation-options)
- [GitHub Releases Downloader](#-github-releases-downloader)
- [Use Cases](#-use-cases)
- [System Requirements](#-system-requirements)
- [Architecture](#-architecture)
- [Advanced Configuration](#-advanced-configuration)
- [Maintenance](#-maintenance)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [Support](#-support)
- [License](#-license)
- [Disclaimer](#-disclaimer)

## 🚀 Quick Start

```bash
# Install Ansible (use pip for latest version)
python3 -m pip install --user ansible

# or
pipx install ansible

# Clone this repository
git clone https://github.com/sachinn403/kali-Playbook-Ansible.git
cd kali-Playbook-Ansible

# Install Ansible Galaxy requirements
ansible-galaxy install -r requirements.yml

# Make the wrapper script executable
chmod +x run-playbook.sh

# Run the playbook
./run-playbook.sh
```

## 🔑 Key Features

- **Structured Tool Organization**: All tools systematically organized by category in the `/opt` directory
- **Comprehensive Coverage**: 200+ security tools across multiple domains
- **Automatic Configuration**: Pre-configured for immediate use after installation
- **Selective Installation**: Tag-based deployment to install only what you need
- **Global Access**: All key tools symlinked to `/usr/local/bin` for system-wide availability
- **GitHub Releases Downloader**: Efficient Go-based tool for downloading specific releases from GitHub repositories
- **Continuous Updates**: Easily keep all tools updated with a single command
- **Minimal Footprint**: Efficient installation without unnecessary dependencies
- **Full Documentation**: Well-documented code and tool organization

## 🗂️ Tool Categories

The playbook organizes tools into dedicated directories following a logical structure:

| Directory              | Purpose                           | Examples                             |
|------------------------|-----------------------------------|--------------------------------------|
| /opt/resources/        | Wordlists & reference materials   | SecLists, PayloadsAllTheThings       |
| /opt/recon/            | Reconnaissance tools              | Subfinder, Amass, Rustscan           |
| /opt/web/              | Web application security          | Nuclei, Katana, Dalfox               |
| /opt/ActiveDirectory/  | Active Directory assessment       | BloodHound, Certipy, CrackMapExec    |
| /opt/cloud/            | Cloud security tools              | Cloudfox, Pacu, ScoutSuite           |
| /opt/c2/               | Command & Control frameworks      | Sliver, Mythic, Empire               |
| /opt/windows-binaries/ | Windows tools (for transfer)      | SharpCollection, Rubeus, PowerSploit |
| /opt/utilities/        | Tunneling and utility tools       | Chisel, Ligolo-NG, Naabu             |
| /opt/reverse-shell/    | Reverse shell handlers            | Penelope, Socat, ConPtyShell         |
| /opt/mobile/           | Mobile security tools             | MobSF, Objection                     |
| /opt/iot/              | IoT/Hardware security             | RouterSploit, Binwalk                |
| /opt/misc/             | Tools that don't fit elsewhere    | Chainsaw, PEASS-ng                   |
| /opt/nuclei/           | Nuclei vulnerability scanner      | Nuclei binaries                      |
| /opt/nuclei-templates/ | Templates for Nuclei scanner      | Security checks and templates         |
| /opt/bloodhound/       | AD visualization and attack paths | BloodHound binaries                  |

## 📋 Installation Options

### Using the Wrapper Script

```bash
# Run the complete installation
./run-playbook.sh

# Display help information
./run-playbook.sh -h

# Run only tasks with specific tags
./run-playbook.sh -t tools

# Skip tasks with specific tags
./run-playbook.sh -s browser

# Increase verbosity for troubleshooting
./run-playbook.sh -v

# Specify a custom log file
./run-playbook.sh --log custom.log
```

### Using Direct Ansible Commands

```bash
# Full installation
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K

# Install specific categories
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K --tags "web,recon"

# Install only C2 frameworks
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K --tags "c2"

# Install tools from GitHub releases
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K --tags github-releases

# Skip specific tasks
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K --skip-tags "mobile,iot"

# Check mode (dry run)
ansible-playbook playbooks/main.yml -i inventory/hosts.ini -K --check
```

### Testing GitHub Releases Downloader

```bash
# Run the test playbook for GitHub releases
ansible-playbook test-github-releases.yml -v

# Check if specific tools were installed
ls -la /opt/nuclei/
ls -la /opt/bloodhound/
```

## 🔽 GitHub Releases Downloader

The toolkit includes a powerful Go-based GitHub releases downloader that efficiently fetches pre-built binaries from GitHub repositories with these features:

- Regex pattern matching for asset selection
- Automatic extraction of ZIP and TAR.GZ archives
- File existence checking to avoid redundant downloads
- Custom output filename support
- Verbose output mode for debugging
- GitHub API token support for authenticated requests
- Configurable timeout settings
- Proper error handling

### Using the GitHub Releases Downloader

```bash
# General syntax
githubdownload -repo=owner/repo -pattern=regex -dest=/path/to/save [-filename=custom.name] [-verbose]

# Download Nuclei (latest version)
githubdownload -repo projectdiscovery/nuclei -pattern "^nuclei_.*_linux_amd64.zip$" -dest /opt/nuclei -verbose

# Download a specific binary with a custom filename
githubdownload -repo r3curs1v3-pr0xy/shurkutlo -pattern "^shurkutlo_linux_amd64" -dest /opt/shurkutlo -filename shurkutlo -verbose
```

## 📊 Use Cases

| Use Case | Tool Categories | Key Tools |
|----------|----------------|-----------|
| **Web Application Penetration Testing**<br>Comprehensive assessment of web applications for vulnerabilities | web, recon, utilities | Nuclei, Katana, Dalfox, FFUF, Burp Suite |
| **Active Directory Assessment**<br>Testing the security of Windows domains and AD infrastructure | ActiveDirectory, windows-binaries, utilities | BloodHound, CrackMapExec, Certipy, Rubeus |
| **Cloud Infrastructure Testing**<br>Security assessment of AWS, Azure, GCP environments | cloud, recon, utilities | CloudFox, Pacu, ScoutSuite, AzureHound |
| **Red Team Operations**<br>Full-scope adversary simulation and persistence | c2, ActiveDirectory, utilities, reverse-shell | Sliver, Empire, Mythic, Covenant, Ligolo-NG |
| **Mobile Application Security**<br>Testing Android and iOS applications | mobile, utilities, recon | MobSF, Objection, Frida |

## 🔧 System Requirements

- **Operating System**: Kali Linux (latest version recommended)
- **RAM**: 8GB+ (16GB+ recommended for running multiple tools simultaneously)
- **Storage**: 50GB+ free space
- **Processor**: Modern multi-core CPU
- **Network**: Internet connection for downloading tools
- **Go**: 1.18 or higher (for GitHub releases downloader)
- **Python**: 3.9 or higher
- **Ansible**: 2.12 or higher

## 🏗 Architecture

The playbook implements a structured, modular architecture designed for maintainability and scalability:

```
Kali Arsenal Architecture
├── Main Playbook (main.yml)
│   ├── Role: install-tools
│   │   ├── Task: System packages
│   │   ├── Task: GitHub repositories
│   │   ├── Task: GitHub releases
│   │   ├── Task: Go tools
│   │   ├── Task: Python tools
│   │   └── Task: Create symlinks
│   ├── Role: configure-system
│   ├── Role: configure-tmux
│   └── Role: customize-terminal
└── Tool Organization
    ├── Category-based directories (/opt/*)
    ├── Global binary symlinks (/usr/local/bin)
    └── Configuration files
```

The playbook follows a modular architecture with these key components:

1. **Core Ansible Playbook** - Orchestrates the entire installation process
2. **Role-Based Organization** - Separates responsibilities into distinct roles
3. **Category-Based Tool Management** - Organizes tools by function
4. **Global Binary Access** - Provides system-wide tool availability via symlinks
5. **Dependency Resolution** - Automatically handles tool prerequisites
6. **Update Mechanism** - Facilitates keeping all tools current

## 🔍 Advanced Configuration

The playbook includes several advanced configurations:

- **Tool Updates**: All tools are cloned with `update: yes` to enable easy updates
- **Binary Accessibility**: Core tools are symlinked to `/usr/local/bin` for global access
- **Release Management**: GitHub releases are downloaded using a custom Go script
- **Build Dependencies**: Handles dependencies for compiled tools automatically

### Configure Security Tool Categories

Edit the `security_tools_to_install` variable to include only the categories you need:

```yaml
security_tools_to_install:
  - web                    # Web application testing tools
  - network                # Network testing tools
  - cloud                  # Cloud security tools
  - active_directory       # Active Directory testing tools
  # - bluetooth            # Comment out to skip bluetooth tools
  # - mobile               # Comment out to skip mobile testing tools
```

## 🛠️ Maintenance

### Updating Tools

Most tools can be updated by re-running the playbook:

```bash
./run-playbook.sh
```

For manual updates of specific tools:

```bash
cd /opt/[category]/[tool]
git pull
```

### Adding Custom Tools

#### Adding a GitHub Repository

To add a new tool from a Git repository, edit `roles/install-tools/tasks/github-repos.yml`:

```yaml
- name: Clone [category] tools
  git:
    repo: "{{ item.repo }}"
    dest: "/opt/[category]/{{ item.name }}"
    update: yes
    depth: 1
  loop:
    - { name: 'existing-tool', repo: 'https://github.com/author/existing-tool' }
    - { name: 'new-tool', repo: 'https://github.com/author/new-tool' }  # Add your tool here
  tags: [category]
  become: true
  become_method: sudo
```

#### Adding a GitHub Release

To add a tool from GitHub releases, edit `roles/install-tools/tasks/github-releases.yml`:

```yaml
- name: Download New Tool
  block:
    - name: Download Tool Binary
      shell: >
        githubdownload -repo author/tool -pattern "^tool.*linux_amd64.zip$" 
        -dest "/opt/tool" -verbose
      args:
        creates: "/opt/tool/binary"
      register: tool_download
      
    - name: Create symlink for Tool
      file:
        src: "/opt/tool/binary"
        dest: "/usr/local/bin/tool"
        state: link
      become: true
      when: tool_download.changed
  when: "'category' in security_tools_to_install"
  tags: [tool, category]
```

## 📘 Documentation

Each tool category contains specific tools for different purposes:

- **Recon tools**: Network scanning, subdomain enumeration, asset discovery
- **Web tools**: Vulnerability scanning, API testing, content discovery
- **AD tools**: Windows domain assessment, credential testing, and privilege escalation
- **C2 frameworks**: Post-exploitation management and implant control
- **Reverse shell tools**: Shell handlers with advanced features for better post-exploitation

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

Please follow the existing code style and organization structure when contributing.

### Testing

Test your changes thoroughly before submitting a pull request.

## 💬 Support

- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For questions and community support
- **Email**: For private inquiries (see GitHub profile)

## 🙏 Credits

This project draws inspiration from the incredible work of [IppSec](https://github.com/IppSec), whose detailed walkthroughs and technical expertise have been invaluable to the security community. Many of the tools and techniques included in this playbook have been demonstrated and explained in his content.

Special thanks to:

- **[IppSec](https://github.com/IppSec)** for his exceptional [HTB walkthroughs and security content](https://www.youtube.com/c/ippsec), particularly his [parrot-build repository](https://github.com/IppSec/parrot-build/) which inspired this project's structure
- **The Kali Linux team** for maintaining the base distribution
- **The Ansible community** for their powerful automation framework
- **All the tool developers** whose work makes this toolkit possible

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This toolkit should only be used for lawful, authorized security testing. The author is not responsible for misuse or illegal activities.

---

<p align="center">
  <a href="https://github.com/sachinn403"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/></a>
  <a href="https://twitter.com/sachinn403"><img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter"/></a>
  <a href="https://www.linkedin.com/in/sachinn403/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/></a>
</p>

<p align="center">
  Built with ❤️ for the security community
</p>

<p align="center">
  © 2025 Sachin Nishad. All rights reserved.
</p>