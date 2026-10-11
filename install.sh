#!/bin/bash
# Install script for kde-wayland-clipboard-bridge

set -e

echo "📦 Installing KDE Wayland Clipboard Bridge..."

# Get the full home path
USER_NAME=$(whoami)
HOME_PATH="/home/$USER_NAME"
SCRIPT_PATH="$HOME_PATH/.local/bin/wayland-spice-clipboard.sh"

echo "📝 User: $USER_NAME"
echo "📝 Script path: $SCRIPT_PATH"

# Detect package manager
if command -v rpm-ostree &>/dev/null; then
    PKG_MANAGER="rpm-ostree"
    INSTALL_CMD="sudo rpm-ostree install"
    REBOOT_REQUIRED=true
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    REBOOT_REQUIRED=false
elif command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt install -y"
    REBOOT_REQUIRED=false
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    REBOOT_REQUIRED=false
else
    echo "❌ No supported package manager found."
    echo "Please install: wl-clipboard, xclip, spice-vdagent"
    exit 1
fi

echo "📦 Detected package manager: $PKG_MANAGER"

# Install dependencies
echo "📦 Installing dependencies..."
$INSTALL_CMD wl-clipboard xclip spice-vdagent || {
    echo "⚠️  Warning: Some packages may already be installed or require a reboot."
    if [ "$REBOOT_REQUIRED" = true ]; then
        echo "📝 On Kinoite/Silverblue, packages are layered and will be available after reboot."
    fi
}

echo "✅ Dependencies processed"

# Create directories
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/autostart

# Install script
echo "📝 Installing clipboard bridge script..."
cp wayland-spice-clipboard.sh ~/.local/bin/
chmod +x ~/.local/bin/wayland-spice-clipboard.sh

# Install service from the repository file
echo "📝 Installing systemd service..."
cp wayland-spice-clipboard.service ~/.config/systemd/user/
echo "✅ Service file copied from repository"

systemctl --user daemon-reload

# Install autostart
echo "📝 Installing KDE autostart entry..."
cp import-env.desktop ~/.config/autostart/

# Import environment NOW (for current session)
echo "🔧 Importing environment for current session..."
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR 2>/dev/null || {
    echo "⚠️  Could not import environment. This may be because you're not in a graphical session."
}

# Restart the service to pick up the environment
echo "🔄 Restarting service..."
systemctl --user enable wayland-spice-clipboard.service 2>/dev/null || true
systemctl --user restart wayland-spice-clipboard.service 2>/dev/null || {
    echo "⚠️  Could not start service. This may be because you're not in a graphical session."
    echo "📝 The service will start automatically on next login."
}

echo ""
echo "✅ Installation complete!"
echo ""
echo "📋 What was installed:"
echo "  • Script: $SCRIPT_PATH"
echo "  • Service: ~/.config/systemd/user/wayland-spice-clipboard.service"
echo "  • Autostart: ~/.config/autostart/import-env.desktop"
echo ""

if [ "$REBOOT_REQUIRED" = true ]; then
    echo "⚠️  Kinoite/Silverblue detected!"
    echo "📝 Packages were layered with rpm-ostree."
    echo "🔄 Please reboot to apply changes:"
    echo ""
    echo "    sudo reboot"
    echo ""
    echo "📝 After reboot, the service will start automatically on login."
else
    echo "📝 The service is now running in your current session."
    echo "📝 It will also start automatically on future logins."
    echo ""
    echo "🔄 To check status: systemctl --user status wayland-spice-clipboard.service"
fi
