# Copy configuration files (fallback method)
copy_configs() {
    header "Copying Configuration Files"
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if config directories exist in script directory or current directory
    CONFIG_SOURCE=""
    if [ -d "$SCRIPT_DIR/.config" ]; then
        CONFIG_SOURCE="$SCRIPT_DIR"
        log "Found config files in script directory: $SCRIPT_DIR"
    elif [ -d ".config" ]; then
        CONFIG_SOURCE="$(pwd)"
        log "Found config files in current directory: $(pwd)"
    else
        error "This shouldn't happen - config files should have been handled by clone_repo()"
        return 1
    fi
    
    # Backup existing configs
    if [ -d "$HOME/.config" ]; then
        log "Backing up existing .config..."
        mv "$HOME/.config" "$HOME/.config.backup.$(date +%Y%m%d_%H%M%S)" || warn "Failed to backup .config"
    fi
    
    if [ -d "$HOME/.local" ]; then
        log "Backing up existing .local..."
        mv "$HOME/.local" "$HOME/.local.backup.$(date +%Y%m%d_%H%M%S)" || warn "Failed to backup .local"
    fi
    
    if [ -f "$HOME/.zshrc" ]; then
        log "Backing up existing .zshrc..."
        mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" || warn "Failed to backup .zshrc"
    fi
    
    # Copy new configs
    log "Copying .config directory..."
    cp -r "$CONFIG_SOURCE/.config" "$HOME/" || error "Failed to copy .config"
    
    if [ -d "$CONFIG_SOURCE/.local" ]; then
        log "Copying .local directory..."
        cp -r "$CONFIG_SOURCE/.local" "$HOME/" || warn "Failed to copy .local"
    fi
    
    if [ -f "$CONFIG_SOURCE/.zshrc" ]; then
        log "Copying .zshrc..."
        cp "$CONFIG_SOURCE/.zshrc" "$HOME/" || warn "Failed to copy .zshrc"
    fi
}#!/bin/bash

# Dotfiles Setup Script for Arch Linux & Fedora
# Author: Professional Setup Script
# Version: 1.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

header() {
    echo -e "${BLUE}===========================================${NC}"
    echo -e "${BLUE} $1 ${NC}"
    echo -e "${BLUE}===========================================${NC}"
}

# Detect distribution
detect_distro() {
    if [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ] || command -v pacman &> /dev/null; then
        DISTRO="arch"
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
        UPDATE_CMD="sudo pacman -Syu --noconfirm"
    elif [ -f /etc/fedora-release ] || command -v dnf &> /dev/null; then
        DISTRO="fedora"
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
        UPDATE_CMD="sudo dnf update -y"
    else
        error "Unsupported distribution! This script supports Arch Linux and Fedora only."
        exit 1
    fi
    
    log "Detected distribution: $DISTRO"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root!"
        exit 1
    fi
}

# Update system
update_system() {
    header "Updating System"
    log "Updating package database..."
    $UPDATE_CMD
}

# Check and install git if needed
check_git() {
    if ! command -v git &> /dev/null; then
        log "Git is not installed. Installing git..."
        case $DISTRO in
            "arch")
                sudo pacman -S --noconfirm git base-devel
                ;;
            "fedora")
                sudo dnf install -y git make gcc
                ;;
        esac
        log "Git installed successfully!"
    else
        log "Git is already installed."
    fi
}

# Install yay for Arch-based systems
install_yay() {
    if [[ $DISTRO == "arch" ]]; then
        if ! command -v yay &> /dev/null; then
            echo -e "${YELLOW}yay AUR helper is not installed.${NC}"
            read -p "Do you want to install yay? (Y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                log "Installing yay..."
                # Ensure git and base-devel are installed
                check_git
                cd /tmp
                git clone https://aur.archlinux.org/yay-bin.git
                cd yay-bin
                makepkg -si --noconfirm
                cd ..
                rm -rf yay-bin
                log "yay installed successfully!"
            else
                warn "Skipping yay installation. Some AUR packages won't be installed."
                return 1
            fi
        else
            log "yay is already installed."
        fi
    fi
    return 0
}

# Install packages for Arch Linux
install_arch_packages() {
    header "Installing Packages for Arch Linux"
    
    # Official repository packages - install all at once
    ARCH_PACKAGES=(
        "hyprland"
        "waybar"
        "kitty"
        "nemo"
        "rofi-wayland"
        "hyprlock"
        "hypridle"
        "tesseract"
        "tesseract-data-tur"
        "tesseract-data-eng"
        "tesseract-data-rus"
        "tesseract-data-kor"
        "wlogout"
        "cliphist"
        "wl-clipboard"
        "swww"
        "zsh"
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "swaync"
        "swayosd"
        "neovim"
        "firefox"
        "papirus-icon-theme"
        "ttf-ubuntu-font-family"
        "ttf-ubuntu-mono-nerd"
        "terminus-font"
        "nwg-look"
    )
    
    log "Installing all official packages in one command..."
    if ! $INSTALL_CMD "${ARCH_PACKAGES[@]}"; then
        warn "Batch installation failed. Trying individual installations..."
        for package in "${ARCH_PACKAGES[@]}"; do
            log "Installing $package..."
            $INSTALL_CMD "$package" || warn "Failed to install $package"
        done
    fi
    
    # AUR packages (if yay is available) - install individually
    if command -v yay &> /dev/null; then
        AUR_PACKAGES=(
            "gtkhash-nemo"
            "xcursor-breeze"
            "catppuccin-gtk-theme-mocha"
            "polkit-kde-agent"
        )
        
        log "Installing AUR packages..."
        for package in "${AUR_PACKAGES[@]}"; do
            log "Installing $package from AUR..."
            yay -S --noconfirm "$package" || warn "Failed to install $package from AUR"
        done
    else
        warn "yay not available. Skipping AUR packages."
    fi
}

# Install packages for Fedora
install_fedora_packages() {
    header "Installing Packages for Fedora"
    
    # Enable RPM Fusion repositories
    log "Enabling RPM Fusion repositories..."
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm || warn "Failed to enable RPM Fusion"
    
    # Enable COPR repositories for Hyprland ecosystem
    log "Enabling COPR repositories..."
    sudo dnf copr enable -y solopasha/hyprland || warn "Failed to enable Hyprland COPR"
    
    FEDORA_PACKAGES=(
        "hyprland"
        "waybar"
        "kitty"
        "nemo"
        "rofi-wayland"
        "hyprlock"
        "hypridle"
        "tesseract"
        "tesseract-langpack-tur"
        "tesseract-langpack-eng"
        "tesseract-langpack-rus"
        "tesseract-langpack-kor"
        "wlogout"
        "cliphist"
        "wl-clipboard"
        "swww"
        "zsh"
        "zsh-syntax-highlighting"
        "zsh-autosuggestions"
        "SwayNotificationCenter"
        "swayosd"
        "neovim"
        "firefox"
        "papirus-icon-theme"
        "ubuntu-family-fonts"
        "terminus-fonts"
        "polkit-kde"
    )
    
    log "Installing packages..."
    for package in "${FEDORA_PACKAGES[@]}"; do
        log "Installing $package..."
        $INSTALL_CMD "$package" || warn "Failed to install $package"
    done
    
    # Install additional packages via flatpak if needed
    log "Installing additional packages via flatpak..."
    flatpak install -y flathub org.gtk.Gtk3theme.Catppuccin-Mocha || warn "Failed to install Catppuccin theme via flatpak"
}

# Install Oh My Zsh
install_ohmyzsh() {
    header "Installing Oh My Zsh"
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log "Oh My Zsh installed successfully!"
    else
        log "Oh My Zsh is already installed."
    fi
}

# Clone repository if needed
clone_repo() {
    header "Checking Configuration Files"
    
    # Get the script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if config directories exist in script directory or current directory
    if [ -d "$SCRIPT_DIR/.config" ]; then
        log "Found config files in script directory: $SCRIPT_DIR"
        return 0
    elif [ -d ".config" ]; then
        log "Found config files in current directory: $(pwd)"
        return 0
    else
        log "Config files not found locally. Cloning hyprconfig repository..."
        
        # Clone the repository
        git clone https://github.com/skyfall3215/hyprconfig.git /tmp/hyprconfig
        
        if [ -d "/tmp/hyprconfig/.config" ]; then
            log "Repository cloned successfully!"
            # Copy configs from cloned repo
            cp -r /tmp/hyprconfig/.config "$HOME/" || error "Failed to copy .config"
            
            if [ -d "/tmp/hyprconfig/.local" ]; then
                cp -r /tmp/hyprconfig/.local "$HOME/" || warn "Failed to copy .local"
            fi
            
            if [ -f "/tmp/hyprconfig/.zshrc" ]; then
                cp "/tmp/hyprconfig/.zshrc" "$HOME/" || warn "Failed to copy .zshrc"
            fi
            
            # Clean up
            rm -rf /tmp/hyprconfig
            
            # Set proper permissions
            log "Setting proper permissions..."
            chmod -R 755 "$HOME/.config" 2>/dev/null || warn "Failed to set .config permissions"
            [ -d "$HOME/.local" ] && chmod -R 755 "$HOME/.local" 2>/dev/null || warn "Failed to set .local permissions"
            [ -f "$HOME/.zshrc" ] && chmod 644 "$HOME/.zshrc" 2>/dev/null || warn "Failed to set .zshrc permissions"
            
            return 0
        else
            error "Failed to find .config in cloned repository!"
            return 1
        fi
    fi
}

# Change default shell to zsh
change_shell() {
    header "Changing Default Shell"
    
    if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
        log "Changing default shell to zsh..."
        chsh -s "$(which zsh)" || warn "Failed to change default shell. You may need to do this manually."
        log "Default shell changed to zsh. Please log out and log back in for changes to take effect."
    else
        log "Default shell is already zsh."
    fi
}

# Post-installation tasks
post_install() {
    header "Post-Installation Tasks"
    
    log "Reloading font cache..."
    fc-cache -fv || warn "Failed to reload font cache"
    
    log "Setting up Hyprland..."
    # Create necessary directories
    mkdir -p "$HOME/.cache/hyprland" || warn "Failed to create Hyprland cache directory"
    
    log "Setting up themes..."
    # Apply GTK theme
    gsettings set org.gnome.desktop.interface gtk-theme "catppuccin-mocha-yellow-standard" 2>/dev/null || warn "Failed to set GTK theme"
    gsettings set org.gnome.desktop.interface icon-theme "Papirus" 2>/dev/null || warn "Failed to set icon theme"
    
    log "Setup completed successfully!"
    log "Please reboot your system to ensure all changes take effect."
    log "After reboot, log in with Hyprland session."
}

# Main function
main() {
    header "Professional Dotfiles Setup Script"
    log "Starting installation process..."
    
    check_root
    detect_distro
    check_git
    update_system
    
    case $DISTRO in
        "arch")
            install_yay
            install_arch_packages
            ;;
        "fedora")
            install_fedora_packages
            ;;
    esac
    
    install_ohmyzsh
    clone_repo
    copy_configs
    change_shell
    post_install
    
    header "Installation Complete!"
    echo -e "${GREEN}Your dotfiles have been successfully installed!${NC}"
    echo -e "${YELLOW}Please reboot your system and select Hyprland from your display manager.${NC}"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
