### Steam
```bash
dpkg --add-architecture i386
sudo apt update
sudo apt install mesa-vulkan-drivers libglx-mesa:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386 -y
sudo apt install steam-installer -y
```

### Flathub
```bash
sudo apt install flatpak -y
sudo apt install plasma-discover-backend-flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### Natives
```bash
sudo apt install ffmpeg -y
sudo apt install git -y
sudo apt install mangohud -y
sudo apt install timeshift -y
sudo apt install konqueror -y
```

### Flatpaks
```bash
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
```

### Others
```bash
flatpak install flathub org.kde.okular -y
sudo software-properties-qt
```
