#!/bin/bash
# =================================================================
# DEBIAN TRIXIE: POMPELMO PRO - CORE
# GitHub: https://github.com/UncleDan/pompelmo-pro
# =================================================================

echo "--- 1. Repo MX Linux & Chiavi ---"
sudo apt update && sudo apt install -y wget gpg ufw
wget https://mxrepo.com/mx/repo/pool/main/m/mx-archive-keyring/mx-archive-keyring_2022.06.01_all.deb
sudo dpkg -i mx-archive-keyring_2022.06.01_all.deb
echo "deb https://mxrepo.com/mx/repo/ trixie main non-free" | sudo tee /etc/apt/sources.list.d/mx.list

echo "--- 2. Interfaccia & Core Terminal ---"
sudo apt update
sudo apt install -y --no-install-recommends \
    kde-plasma-desktop sway xwayland sddm \
    plasma-nm pipewire-audio wireplumber \
    foot foot-themes dolphin konqueror

echo "--- 3. Strumenti MX (Snapshot, Installer, Cleanup) ---"
sudo apt install -y mx-snapshot mx-live-usb-maker mx-usb-unmounter mx-cleanup minstall

echo "--- 4. Container & App Store ---"
sudo apt install -y --no-install-recommends \
    distrobox podman podman-docker \
    plasma-discover plasma-discover-backend-flatpak flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "--- 5. Stampe Core (Driverless) ---"
sudo apt install -y --no-install-recommends \
    cups cups-filters avahi-daemon system-config-printer ghostscript

echo "--- 6. Creazione Icone Menu per MX Tools ---"
sudo mkdir -p /usr/share/applications/
create_mx_launcher() {
    local name=$1
    local exec_cmd=$2
    local icon=$3
    cat <<EOF | sudo tee /usr/share/applications/pompelmo-${name,,}.desktop
[Desktop Entry]
Name=MX ${name} (Pompelmo)
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

echo "--- 7. Firewall (UFW Shield) ---"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 5353/udp && sudo ufw allow 631/tcp
echo "y" | sudo ufw enable

echo "--- 8. Foot Configuration (Server/Client Mode) ---"
mkdir -p ~/.config/foot/
cat <<EOF > ~/.config/foot/foot.ini
[main]
font=monospace:size=11
pad=12x12
[colors]
alpha=0.95
background=1a1a1a
foreground=ffffff
[cursor]
style=block
blink=yes
EOF

echo "--- 9. Sway Integration ---"
mkdir -p ~/.config/sway/
if [ ! -f ~/.config/sway/config ]; then
cat <<EOF > ~/.config/sway/config
# Pompelmo Pro Core
exec foot --server
set \$mod Mod4
set \$term footclient
bindsym \$mod+Return exec \$term
include /etc/sway/config.d/*
EOF
fi

echo "--- 10. Abilitazione Servizi ---"
systemctl --user enable --now pipewire-pulse wireplumber
sudo systemctl enable --now sddm cups avahi-daemon

echo "-------------------------------------------------------"
echo "POMPELMO PRO: INSTALLAZIONE COMPLETATA."
echo "-------------------------------------------------------"