# 🚀 Claude Code Development Environment Installer

Automated installation scripts for setting up a complete Claude Code development environment for functional consultants working with Odoo.

## 📋 What Gets Installed

These scripts will install and configure everything you need:

- **NVM** (Node Version Manager) - Manage multiple Node.js versions
- **Node.js** (Latest LTS) - JavaScript runtime
- **NPM** - Node package manager
- **Claude Code CLI** - Anthropic's AI coding assistant
- **pyenv** - Python version manager
- **Python 3.5+** - With virtual environment support (installs Python 3.13 if needed)

## ✨ Features

- ✅ **Idempotent** - Run multiple times safely, skips already installed components
- ✅ **User-level installation** - No system-wide changes, everything installed for your user
- ✅ **Colored output** - Clear visual feedback with green (success), red (errors), yellow (warnings)
- ✅ **Smart detection** - Checks existing installations and versions
- ✅ **Detailed verification** - Final check ensures everything is properly installed

## 🖥️ Supported Platforms

- **macOS** (Intel and Apple Silicon)
- **Linux** (Debian-based: Ubuntu, Debian, Linux Mint, Pop!_OS, etc.)
- **Windows** (via WSL2 with Ubuntu/Debian)

---

## 🍎 macOS Installation

### Prerequisites

**Important:** Your user account must have **administrator privileges** on macOS. This is required by Homebrew (the package manager).

To check if you have admin rights:
- Open System Settings > Users & Groups
- Your account should show "Admin" under the name

If you don't have admin rights, ask a system administrator to either:
- Grant you administrator privileges, OR
- Run this script while logged in as an administrator

### One-Command Installation

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-macos.sh)
```

### Manual Installation (Recommended)

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-macos.sh -o install-macos.sh

# Make it executable
chmod +x install-macos.sh

# Run it
./install-macos.sh
```

**Note:** The script will ask for your password when installing Homebrew and system dependencies.

---

## 🐧 Linux Installation (Debian-based)

**Supported distributions:** Ubuntu, Debian, Linux Mint, Pop!_OS, Elementary OS, Zorin OS

### One-Command Installation

```bash
curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-linux.sh | bash
```

### Manual Installation

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-linux.sh -o install-linux.sh

# Make it executable
chmod +x install-linux.sh

# Run it
./install-linux.sh
```

**Note:** You may need to enter your sudo password when installing system dependencies.

---

## 🪟 Windows Installation (WSL2)

### Prerequisites

Before running the script, you need WSL2 installed:

1. **Install WSL2** (PowerShell as Administrator):
   ```powershell
   wsl --install
   ```

2. **Restart your computer**

3. **Install Ubuntu from Microsoft Store**

4. **Open Ubuntu terminal**

### One-Command Installation

Inside your WSL2 Ubuntu terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-windows.sh | bash
```

### Manual Installation

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/indawsodoo/ai-claude-install/main/scripts/install-windows.sh -o install-windows.sh

# Make it executable
chmod +x install-windows.sh

# Run it
./install-windows.sh
```

**Note:** You may need to enter your sudo password when installing system dependencies.

---

## 📝 Post-Installation Steps

The script automatically reloads your shell configuration, so all commands should be available immediately!

1. **Verify Claude Code installation**:
   ```bash
   claude doctor
   ```

2. **Start using Claude Code**:
   ```bash
   cd your-project-directory
   claude
   ```

**Note:** If for any reason commands are not found, restart your terminal or manually reload your shell:
   ```bash
   # For bash
   source ~/.bashrc

   # For zsh
   source ~/.zshrc
   ```

## 🔑 Claude Code Subscription

**Important:** Claude Code requires a **Claude Pro** or **Claude Max** subscription to function.

- Visit [https://claude.ai](https://claude.ai) to manage your subscription
- Sign up for Claude Pro or Max if you haven't already

## 🔧 Troubleshooting

### Script fails during installation

1. Check your internet connection
2. Run the script again (it's safe to re-run)
3. Check the error messages for specific issues

### Command not found after installation

1. Close and reopen your terminal
2. Verify the installation paths are in your `~/.bashrc` or `~/.zshrc`
3. Manually source your profile: `source ~/.bashrc` or `source ~/.zshrc`

### WSL2 specific issues

- Ensure WSL2 is properly installed: `wsl --status`
- Update WSL2: `wsl --update`
- Access Windows files from WSL: `/mnt/c/Users/YourUsername/`

### Python version issues

- The script accepts Python 3.5 or higher
- If you have an older version, the script will install Python 3.13 via pyenv
- Check your Python version: `python3 --version`

### Claude Code authentication

- Run `claude` and follow the authentication prompts
- You'll need to sign in with your Anthropic account
- Ensure you have an active Pro or Max subscription

## 📦 What Gets Modified

The scripts make the following changes to your system:

### Files Modified/Created:
- `~/.nvm/` - NVM installation directory
- `~/.pyenv/` - pyenv installation directory
- `~/.local/bin/claude` - Claude Code CLI binary
- `~/.bashrc` or `~/.zshrc` - Shell configuration (appends PATH exports)

### System Packages (Linux only):
- Build tools and development libraries
- Required for compiling Python and Node.js native modules

## 🆘 Getting Help

If you encounter issues:

1. Review the colored output for specific error messages
2. Check that you have sudo privileges
3. Ensure you have a stable internet connection
4. Verify you're running the correct script for your OS

For Claude Code specific issues:
- Run `claude doctor` for diagnostics
- Visit [Claude Code Documentation](https://code.claude.com/docs)
- Check [Claude Code GitHub Issues](https://github.com/anthropics/claude-code/issues)

## 🔄 Updating Components

### Update Claude Code
```bash
# The installation script handles updates
# Or check for manual update instructions
claude --version
```

### Update Node.js
```bash
nvm install --lts
nvm use --lts
```

### Update Python
```bash
pyenv install 3.13.3
pyenv global 3.13.3
```

## 📜 License

These installation scripts are provided as-is for use by Indaws/Dynapps consultants.

## 🤝 Contributing

Found a bug or have a suggestion? Please create an issue or submit a pull request!

---

**Made with ❤️ for all Indaws/Dynapps employees**

Happy coding with Claude! 🤖✨
