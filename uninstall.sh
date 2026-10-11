#!/bin/bash
# Uninstall script for kde-wayland-clipboard-bridge

echo "🗑️  Uninstalling KDE Wayland Clipboard Bridge..."

# Stop and disable the service
echo "🛑 Stopping service..."
systemctl --user stop wayland-spice-clipboard.service 2>/dev/null || true
systemctl --user disable wayland-spice-clipboard.service 2>/dev/null || true

# Remove service file
rm -f ~/.config/systemd/user/wayland-spice-clipboard.service

# Remove autostart entry
rm -f ~/.config/autostart/import-env.desktop

# Remove script
rm -f ~/.local/bin/wayland-spice-clipboard.sh

# Reload systemd
systemctl --user daemon-reload 2>/dev/null || true

echo ""
echo "✅ Uninstall complete!"
echo ""
echo "📝 Dependencies were NOT removed."
