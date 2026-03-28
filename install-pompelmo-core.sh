#!/bin/bash
# =================================================================
# DEBIAN TRIXIE: POMPELMO PRO CORE (Debug Edition)
# The Foundations - Base System & MX Engine Integration
# Credits: Daniele Lolli (UncleDan) feat. Gemini AI
# =================================================================

# Funzione per la pausa di debug
pause_step() {
    echo "-------------------------------------------------------"
    read -p "Blocco completato. Premi [Invio] per continuare o [Ctrl+C] per uscire..."
    echo "-------------------------------------------------------"
}

clear
echo "🚀 AVVIO INSTALLAZIONE: POMPELMO PRO CORE"
echo "Identità: Debian 13 (Trixie) + MX Engine"
echo "======================================================="

echo "--- 1. Repository MX & GPG (Standard ISO MX KDE) ---"
sudo apt update && sudo apt install -y wget gpg ufw
sudo mkdir -p /etc/apt/keyrings
wget -O- https://mxrepo.com/mx/repo/mxrepo.asc | sudo gpg --dearmor -o /etc/apt/keyrings/mx-archive-keyring.gpg
cat <<EOF | sudo tee /etc/apt/sources.list.d/mx.list
# MX Linux Repo - Pompelmo Pro Core Edition
deb [signed-by=/etc/apt/keyrings/mx-archive-keyring.gpg] https://mxrepo.com/mx/repo/ trixie main non-free
EOF
sudo apt update
pause_step

echo "--- 2. Core System: MX Tools & Installer ---"
sudo apt install -y mx-snapshot mx-live-usb-maker mx-cleanup minstall mx-usb-unmounter
pause_step

echo "--- 3. Interfaccia & Terminale (Wayland Native) ---"
sudo apt install -y --no-install-recommends \
    kde-plasma-desktop sway xwayland sddm \
    plasma-nm pipewire-audio wireplumber \
    foot foot-themes dolphin konqueror
pause_step

echo "--- 4. Container Engine (Distrobox) ---"
sudo apt install -y --no-install-recommends \
    distrobox podman podman-docker \
    plasma-discover plasma-discover-backend-flatpak flatpak
pause_step

echo "--- 5. Core Printing (Driverless IPP) ---"
sudo apt install -y --no-install-recommends \
    cups cups-filters avahi-daemon system-config-printer ghostscript
pause_step

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
pause_step

echo "--- 7. Network Shield (UFW) ---"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 5353/udp && sudo ufw allow 631/tcp
echo "y" | sudo ufw enable
pause_step

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
pause_step

echo "--- 9. Enabling Services ---"
systemctl --user enable --now pipewire-pulse wireplumber
sudo systemctl enable --now sddm cups avahi-daemon

echo "======================================================="
echo "✅ POMPELMO PRO CORE: INSTALLAZIONE COMPLETATA"
echo "======================================================="