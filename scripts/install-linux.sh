#!/bin/bash

# ==============================================================================
# Claude Code Development Environment Installer for Linux (Debian-based)
# ==============================================================================
# This script installs everything a functional consultant needs to work with
# Claude Code and Odoo development on Linux (Ubuntu, Debian, Mint, etc.).
#
# Installs:
#   - NVM (Node Version Manager)
#   - Node.js (latest LTS)
#   - Claude Code CLI
#   - pyenv (Python Version Manager)
#   - Python 3.5+ with virtual environment support (if not already present)
#
# This script is idempotent - you can run it multiple times safely!
# ==============================================================================

set -e  # Exit on error

# ==============================================================================
# COLOR CODES - Making terminal output fabulous! 🎨
# ==============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ==============================================================================
# HELPER FUNCTIONS - Because DRY is life
# ==============================================================================

print_header() {
    echo -e "\n${BOLD}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║  $1${NC}"
    echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_step() {
    echo -e "${CYAN}➜ $1${NC}"
}

# ==============================================================================
# OS DETECTION - Are you who you say you are? 🕵️
# ==============================================================================

detect_os() {
    print_step "Detecting operating system..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check if it's Debian-based
        if [ -f /etc/debian_version ]; then
            print_success "Debian-based Linux detected! You're in the right place!"
            return 0
        else
            print_error "This script is for Debian-based Linux only (Ubuntu, Debian, Mint, etc.)!"
            print_info "Current OS: $OSTYPE (non-Debian)"
            exit 1
        fi
    else
        print_error "This script is for Linux only!"
        print_info "Current OS: $OSTYPE"
        print_info "Please use the appropriate script for your OS:"
        print_info "  • macOS: install-macos.sh"
        print_info "  • Windows (WSL2): install-windows.sh"
        exit 1
    fi
}

# ==============================================================================
# SYSTEM DEPENDENCIES - The building blocks
# ==============================================================================

install_system_dependencies() {
    print_header "📦 SYSTEM DEPENDENCIES INSTALLATION"

    print_step "Updating package lists..."
    sudo apt-get update -qq

    print_step "Installing essential build tools and dependencies..."

    # Essential packages for building software
    local packages=(
        build-essential
        curl
        wget
        git
        libssl-dev
        zlib1g-dev
        libbz2-dev
        libreadline-dev
        libsqlite3-dev
        libncursesw5-dev
        xz-utils
        tk-dev
        libxml2-dev
        libxmlsec1-dev
        libffi-dev
        liblzma-dev
    )

    sudo apt-get install -y -qq "${packages[@]}" 2>&1 | grep -v "is already the newest version" || true

    print_success "System dependencies installed successfully!"
}

# ==============================================================================
# NVM INSTALLATION - Node Version Manager
# ==============================================================================

check_nvm() {
    if [ -d "$HOME/.nvm" ] && [ -s "$HOME/.nvm/nvm.sh" ]; then
        return 0
    else
        return 1
    fi
}

install_nvm() {
    print_header "📦 NVM (NODE VERSION MANAGER) INSTALLATION"

    if check_nvm; then
        # Source NVM to get version
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        local nvm_version=$(nvm --version 2>/dev/null || echo "unknown")
        print_success "NVM is already installed! (v$nvm_version)"
        return 0
    fi

    print_step "NVM not found. Installing Node Version Manager..."

    # Download and install NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if check_nvm; then
        print_success "NVM installed successfully! Node.js versions are now manageable!"
    else
        print_error "NVM installation failed!"
        exit 1
    fi
}

# ==============================================================================
# NODE.JS INSTALLATION - JavaScript runtime
# ==============================================================================

check_nodejs() {
    if command -v node &> /dev/null; then
        return 0
    else
        return 1
    fi
}

install_nodejs() {
    print_header "🟢 NODE.JS INSTALLATION"

    # Make sure NVM is loaded
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if check_nodejs; then
        local node_version=$(node --version)
        local npm_version=$(npm --version)
        print_success "Node.js is already installed! ($node_version)"
        print_success "NPM is ready to roll! (v$npm_version)"
        return 0
    fi

    print_step "Installing Node.js LTS (Long Term Support)..."

    # Load NVM and install Node.js
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts && nvm use --lts && nvm alias default lts/*

    if check_nodejs; then
        local node_version=$(node --version)
        local npm_version=$(npm --version)
        print_success "Node.js installed successfully! ($node_version) 🚀"
        print_success "NPM is locked and loaded! (v$npm_version)"
    else
        print_error "Node.js installation failed!"
        exit 1
    fi
}

# ==============================================================================
# CLAUDE CODE INSTALLATION - The star of the show! ⭐
# ==============================================================================

check_claude_code() {
    if command -v claude &> /dev/null; then
        return 0
    else
        return 1
    fi
}

install_claude_code() {
    print_header "🤖 CLAUDE CODE CLI INSTALLATION"

    if check_claude_code; then
        local claude_version=$(claude --version 2>/dev/null || echo "unknown")
        print_success "Claude Code is already installed! ($claude_version)"
        print_info "Run 'claude doctor' to check your setup!"
        return 0
    fi

    print_step "Installing Claude Code CLI..."
    print_info "Using the official installation script..."
    print_warning "This may take a few minutes, please be patient..."
    echo ""

    # Use the official installation script
    curl -fL https://claude.ai/install.sh | bash

    echo ""
    # Reload shell to pick up claude command
    export PATH="$HOME/.local/bin:$PATH"

    if check_claude_code; then
        print_success "Claude Code installed successfully! 🎉"
        print_info "You can now use 'claude' command in your terminal!"
        print_warning "Remember: You need a Claude Pro/Max subscription to use Claude Code"
    else
        print_error "Claude Code installation failed!"
        print_warning "You might need to restart your terminal and try again"
        exit 1
    fi
}

# ==============================================================================
# PYENV INSTALLATION - Python Version Manager
# ==============================================================================

check_pyenv() {
    if [ -d "$HOME/.pyenv" ] && [ -s "$HOME/.pyenv/bin/pyenv" ]; then
        return 0
    else
        return 1
    fi
}

install_pyenv() {
    print_header "🐍 PYENV (PYTHON VERSION MANAGER) INSTALLATION"

    if check_pyenv; then
        # Load pyenv to get version
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        local pyenv_version=$($PYENV_ROOT/bin/pyenv --version 2>/dev/null | cut -d' ' -f2 || echo "installed")
        print_success "pyenv is already installed! (v$pyenv_version)"
        return 0
    fi

    print_step "Installing pyenv..."

    # Use the official pyenv installer
    curl https://pyenv.run | bash

    # Load pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null || true
    eval "$(pyenv init -)" 2>/dev/null || true

    if check_pyenv; then
        print_success "pyenv installed successfully! Python versions are now yours to command!"
    else
        print_error "pyenv installation failed!"
        exit 1
    fi
}

# ==============================================================================
# PYTHON INSTALLATION - The snake that bites... bugs! 🐍
# ==============================================================================

check_python() {
    if command -v python3 &> /dev/null; then
        local version=$(python3 --version 2>&1 | grep -oP '\d+\.\d+\.\d+' || echo "0.0.0")
        local major=$(echo $version | cut -d'.' -f1)
        local minor=$(echo $version | cut -d'.' -f2)

        # Accept Python 3.5 or higher
        if [ "$major" -ge 3 ] && [ "$minor" -ge 5 ]; then
            return 0
        fi
    fi
    return 1
}

install_python() {
    print_header "🐍 PYTHON INSTALLATION"

    if check_python; then
        local python_version=$(python3 --version)
        print_success "Python is already installed and meets requirements! ($python_version)"
        print_step "Checking pip..."
        if command -v pip3 &> /dev/null; then
            local pip_version=$(pip3 --version | cut -d' ' -f2)
            print_success "pip is ready! (v$pip_version)"
        else
            print_step "Installing pip..."
            sudo apt-get install -y python3-pip
        fi

        print_step "Checking venv support..."
        if python3 -m venv --help &> /dev/null; then
            print_success "Virtual environment support is available!"
        else
            print_step "Installing python3-venv..."
            sudo apt-get install -y python3-venv
        fi
        return 0
    fi

    print_step "Python 3.5+ not found. Installing Python 3.13 (latest stable)..."
    print_info "This might take a few minutes - perfect time for a coffee! ☕"

    # Make sure pyenv is loaded
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null || true
    eval "$(pyenv init -)" 2>/dev/null || true

    # Install Python 3.13
    pyenv install 3.13.3 -s && pyenv global 3.13.3

    if check_python; then
        local python_version=$(python3 --version)
        print_success "Python installed successfully! ($python_version) 🎉"
        print_success "Virtual environments are ready to use with 'python -m venv'!"

        # Verify pip
        if command -v pip3 &> /dev/null; then
            pip3 install --upgrade pip
            local pip_version=$(pip3 --version | cut -d' ' -f2)
            print_success "pip upgraded and ready! (v$pip_version)"
        fi
    else
        print_error "Python installation failed!"
        exit 1
    fi
}

# ==============================================================================
# SHELL CONFIGURATION - Auto-configure shell profiles
# ==============================================================================

configure_shell() {
    print_header "🔧 SHELL CONFIGURATION"

    # Determine which shell config file to use (priority: zsh > bash)
    local shell_config=""
    if [ -f "$HOME/.zshrc" ]; then
        shell_config="$HOME/.zshrc"
        print_step "Configuring Zsh (~/.zshrc)..."
    elif [ -f "$HOME/.bashrc" ]; then
        shell_config="$HOME/.bashrc"
        print_step "Configuring Bash (~/.bashrc)..."
    else
        # Create .bashrc if neither exists
        shell_config="$HOME/.bashrc"
        touch "$shell_config"
        print_step "Created ~/.bashrc for configuration..."
    fi

    local config_marker="# Claude Code Environment - Added by ai-claude-install"
    local needs_update=false

    # Check if configuration already exists
    if grep -q "$config_marker" "$shell_config"; then
        print_success "Configuration already exists in $shell_config"
        return 0
    fi

    print_step "Adding environment configuration..."

    # Add configuration block
    cat >> "$shell_config" << EOF

$config_marker
# Claude Code CLI
export PATH="\$HOME/.local/bin:\$PATH"

# NVM (Node Version Manager)
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \\. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \\. "\$NVM_DIR/bash_completion"

# Pyenv (Python Version Manager)
export PYENV_ROOT="\$HOME/.pyenv"
export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
EOF

    print_success "Configuration added to $shell_config"

    # Return the shell config file path for sourcing later
    echo "$shell_config"
}

# ==============================================================================
# FINAL VERIFICATION - Trust, but verify! ✅
# ==============================================================================

verify_installation() {
    print_header "🔍 FINAL VERIFICATION"

    local all_good=true

    print_step "Checking all components..."
    echo ""

    # NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if check_nvm; then
        local nvm_version=$(nvm --version 2>/dev/null || echo "installed")
        print_success "NVM: v$nvm_version"
    else
        print_error "NVM: Not found"
        all_good=false
    fi

    # Node.js
    if check_nodejs; then
        print_success "Node.js: $(node --version)"
        print_success "NPM: v$(npm --version)"
    else
        print_error "Node.js: Not found"
        all_good=false
    fi

    # Claude Code
    export PATH="$HOME/.local/bin:$PATH"
    if check_claude_code; then
        local claude_version=$(claude --version 2>/dev/null || echo "installed")
        print_success "Claude Code: $claude_version"
    else
        print_error "Claude Code: Not found"
        all_good=false
    fi

    # pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)" 2>/dev/null || true
    eval "$(pyenv init -)" 2>/dev/null || true
    if check_pyenv; then
        local pyenv_version=$(pyenv --version | cut -d' ' -f2)
        print_success "pyenv: v$pyenv_version"
    else
        print_error "pyenv: Not found"
        all_good=false
    fi

    # Python
    if check_python; then
        print_success "Python: $(python3 --version)"
        if command -v pip3 &> /dev/null; then
            print_success "pip: v$(pip3 --version | cut -d' ' -f2)"
        fi
    else
        print_error "Python: Not found or version < 3.5"
        all_good=false
    fi

    echo ""

    if $all_good; then
        print_success "═══════════════════════════════════════════════════════════"
        print_success "  🎉 ALL SYSTEMS GO! Your environment is ready! 🚀"
        print_success "═══════════════════════════════════════════════════════════"
        echo ""
        print_info "Next steps:"
        print_info "  1. Run 'claude doctor' to verify Claude Code setup"
        print_info "  2. Run 'claude' in your project directory to start coding!"
        echo ""
        print_warning "Remember: You need a Claude Pro/Max subscription to use Claude Code"
        print_info "Visit: https://claude.ai to manage your subscription"
        echo ""
    else
        print_error "═══════════════════════════════════════════════════════════"
        print_error "  Some components failed to install properly! 😢"
        print_error "═══════════════════════════════════════════════════════════"
        echo ""
        print_info "Try the following:"
        print_info "  1. Restart your terminal"
        print_info "  2. Run this script again"
        print_info "  3. Check the error messages above"
        echo ""
        return 1
    fi
}

# ==============================================================================
# MAIN EXECUTION - Let's do this! 🎬
# ==============================================================================

main() {
    clear

    echo -e "${BOLD}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════════════╗
║                                                                       ║
║     🚀 CLAUDE CODE DEVELOPMENT ENVIRONMENT INSTALLER 🚀              ║
║                                                                       ║
║     For Linux (Debian-based) - Consultant Edition                    ║
║                                                                       ║
║     This script will install:                                        ║
║       • System Build Dependencies                                    ║
║       • NVM (Node Version Manager)                                   ║
║       • Node.js & NPM                                                ║
║       • Claude Code CLI                                              ║
║       • pyenv (Python Version Manager)                               ║
║       • Python 3.5+ with venv support                                ║
║                                                                       ║
║     Sit back, relax, and let the magic happen! ✨                    ║
║                                                                       ║
╚═══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"

    print_info "Installation starting in 3 seconds..."
    sleep 3

    # Run all installation steps
    detect_os
    install_system_dependencies
    install_nvm
    install_nodejs
    install_claude_code
    install_pyenv
    install_python
    SHELL_CONFIG=$(configure_shell)
    verify_installation

    print_success "Installation script completed! 🎊"

    # Source the shell configuration to make everything available immediately
    if [ -f "$SHELL_CONFIG" ]; then
        print_header "🔄 RELOADING SHELL CONFIGURATION"
        print_info "Loading environment variables..."
        source "$SHELL_CONFIG"
        print_success "Environment reloaded! All commands are now available! 🎉"
    fi
}

# Run the main function
main
