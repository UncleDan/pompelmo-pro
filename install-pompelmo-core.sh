#!/bin/bash
# =================================================================
# DEBIAN TRIXIE: POMPELMO PRO CORE
# The Foundations - Base System & MX Engine Integration
# Credits: Daniele Lolli (UncleDan) feat. Gemini AI
# =================================================================

echo "--- 1. Repository MX & GPG (Standard ISO MX KDE) ---"
sudo apt update && sudo apt install -y wget gpg ufw

# Importazione chiave GPG ufficiale MX (metodo moderno signed-by)
sudo mkdir -p /etc/apt/keyrings
wget -O- https://mxrepo.com/mx/repo/mxrepo.asc | sudo gpg --dearmor -o /etc/apt/keyrings/mx-archive-keyring.gpg

# Configurazione Sorgenti MX Linux per Trixie (Debian 13)
# Estrapolato dalla configurazione ufficiale MX-AHS/KDE
cat <<EOF | sudo tee /etc/apt/sources.list.d/mx.list
# MX Linux Repo - Pompelmo Pro Core Edition
deb [signed-by=/etc/apt/keyrings/mx-archive-keyring.gpg] https://mxrepo.com/mx/repo/ trixie main non-free
# Repo AHS (Advanced Hardware Support) opzionale per kernel/firmware recenti
# deb [signed-by=/etc/apt/keyrings/mx-archive-keyring.gpg] https://mxrepo.com/mx/repo/ trixie ahs
EOF

sudo apt update

echo "--- 2. Core System: MX Tools & Installer ---"
# Installazione pacchetti MX certificati per Trixie
sudo apt install -y mx-snapshot mx-live-usb-maker mx-cleanup minstall mx-usb-unmounter

echo "--- 3. Interfaccia & Terminale (Wayland Native) ---"
sudo apt install -y --no-install-recommends \
    kde-plasma-desktop sway xwayland sddm \
    plasma-nm pipewire-audio wireplumber \
    foot foot-themes dolphin konqueror

echo "--- 4. Container Engine (Distrobox) ---"
sudo apt install -y --no-install-recommends \
    distrobox podman podman-docker \
    plasma-discover plasma-discover-backend-flatpak flatpak

echo "--- 5. Core Printing (Driverless IPP) ---"
sudo apt install -y --no-install-recommends \
    cups cups-filters avahi-daemon system-config-printer ghostscript

echo "--- 6. Integrazione Menu (Pompelmo Icons) ---"
sudo mkdir -p /usr/share/applications/
create_mx_launcher() {
    local name=$1
    local exec_cmd=$2
    local icon=$3
    cat <<EOF | sudo tee /usr/share/applications/pompelmo-${name,,}.desktop
[Desktop Entry]
Name=MX ${name} (Core)
Exec=pkexec ${exec_cmd}
Icon=${icon}
Type=Application
Categories=System;Settings;
Terminal=false
EOF
}
create_mx_launcher "Snapshot" "mx-snapshot" "mx-snapshot"
create_mx_launcher "Live USB Maker" "mx-live-usb-maker" "mx-live-usb-maker"
create_mx_launcher "Cleanup" "mx-cleanup" "mx-cleanup"
create_mx_launcher "Installer" "minstall" "minstall"

echo "--- 7. Network Shield (UFW) ---"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 5353/udp && sudo ufw allow 631/tcp
echo "y" | sudo ufw enable

echo "--- 8. Foot & Sway Configuration ---"
mkdir -p ~/.config/foot/ ~/.config/sway/
cat <<EOF > ~/.config/foot/foot.ini
[main]
font=monospace:size=11
pad=12x12
[colors]
alpha=0.95
background=1a1a1a
foreground=ffffff
EOF

if [ ! -f ~/.config/sway/config ]; then
cat <<EOF > ~/.config/sway/config
exec foot --server
set \$mod Mod4
set \$term footclient
bindsym \$mod+Return exec \$term
include /etc/sway/config.d/*
EOF
fi

echo "--- 9. Enabling Services ---"
systemctl --user enable --now pipewire-pulse wireplumber
sudo systemctl enable --now sddm cups avahi-daemon

echo "======================================================="
echo "POMPELMO PRO CORE INSTALLATION COMPLETE"
echo "======================================================="