# KDE Wayland → X11 Clipboard Bridge

A clipboard bridge for KDE Plasma on Wayland that syncs the clipboard to X11 for SPICE/VM clipboard sharing.

## Features

- ✅ Syncs text from Wayland to X11 clipboard
- ✅ MIME-type filtering (ignores files, preserves Dolphin copy/paste)
- ✅ Starts automatically on login
- ✅ Works in Kinoite/Silverblue (immutable systems)

## Installation

```bash
git clone https://github.com/jonathonp3/kde-wayland-clipboard-bridge
cd kde-wayland-clipboard-bridge
chmod +x install.sh
./install.sh
```

How It Works

    Script monitors Wayland clipboard

    Syncs text to X11 clipboard

    SPICE agent sends to VM host

    File operations (text/uri-list) are ignored

Why This Exists

KDE Plasma on Wayland doesn't share clipboard with SPICE guests out of the box. This bridge makes it work.
Files

Files

   wayland-spice-clipboard.sh — The clipboard bridge script
   
   wayland-spice-clipboard.service — systemd user service
   
   import-env.desktop — KDE autostart entry
   
   install.sh — Installation script
   
   uninstall.sh — Clean removal script

Requirements

    KDE Plasma (Wayland session)

    wl-clipboard (for wl-paste)

    xclip (for X11 clipboard)

    spice-vdagent (for VM clipboard sharing)

License

MIT




