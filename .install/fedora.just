#!/bin/bash

echo -e '\n Installing all Fedora apps\n'
sudo dnf install steam -y
sudo dnf install ffmpeg -y
sudo dnf install git -y
sudo dnf install mangohud -y
sudo dnf install kate -y
sudo dnf install timeshift -y
flatpak install flathub org.mozilla.firefox -y
flatpak install flathub com.google.Chrome -y
flatpak install flathub org.gimp.GIMP -y
flatpak install flathub org.qbittorrent.qBittorrent -y
flatpak install flathub org.flameshot.Flameshot -y
flatpak install flathub org.gnome.EasyTAG -y
flatpak install flathub com.stremio.Stremio -y
flatpak install flathub org.bleachbit.BleachBit -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub org.libretro.RetroArch -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub io.github.mimbrero.WhatsAppDesktop -y
flatpak install flathub com.github.tchx84.Flatseal -y
flatpak install flathub net.davidotek.pupgui2 -y
flatpak install flathub net.lutris.Lutris -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.obsproject.Studio -y
flatpak install flathub org.videolan.VLC -y
flatpak install flathub org.kde.okular -y
flatpak install flathub org.kde.kcalc -y
flatpak install flathub org.kde.gwenview -y
echo -e ' All Fedora apps have been installed\n'
