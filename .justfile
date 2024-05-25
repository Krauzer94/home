_default:
	just --list

# Set up user bash_aliases file
setup-aliases:
	#!/bin/bash

	echo -e '\n Setting up the Bash Aliases file\n'
	echo -e "\n# Bash aliases\nif [ -f ~/.bash_aliases ]; then\n. ~/.bash_aliases\nfi" >> ~/.bashrc
	echo -e ' Bash Aliases setup finished\n'

# Install Debian specific apps
installs-debian:
	#!/bin/bash

	echo -e '\n Installing all Debian apps\n'
	sudo apt install network-manager -y
	sudo nano /etc/network/interfaces
	sudo apt install kde-plasma-desktop -y
	sudo dpkg --add-architecture i386
	sudo nano /etc/apt/sources.list
	sudo apt install steam-installer -y
	sudo apt install ffmpeg -y
	sudo apt install git -y
	sudo apt install mangohud -y
	sudo apt install firefox-esr -y
	sudo apt install timeshift -y
	sudo apt install flatpak -y
	sudo apt install plasma-discover-backend-flatpak -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	echo -e ' All Debian apps have been installed\n'

# Install SteamOS specific apps
installs-steamos:
	#!/bin/bash

	echo -e '\n Installing all SteamOS apps\n'
	flatpak install flathub com.google.Chrome -y
	flatpak install flathub org.gimp.GIMP -y
	flatpak install flathub org.qbittorrent.qBittorrent -y
	flatpak install flathub org.videolan.VLC -y
	flatpak install flathub org.flameshot.Flameshot -y
	flatpak install flathub org.gnome.EasyTAG -y
	flatpak install flathub com.stremio.Stremio
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
	echo -e ' All SteamOS apps have been installed\n'

# Install Arch specific apps
installs-arch:
	#!/bin/bash

	echo -e '\n Installing all Arch Linux apps\n'
	sudo pacman -S steam --noconfirm
	sudo pacman -S ffmpeg --noconfirm
	sudo pacman -S git --noconfirm
	sudo pacman -S mangohud --noconfirm
	sudo pacman -S packagekit-qt6 --noconfirm
	sudo pacman -S firefox --noconfirm
	sudo pacman -S flatpak --noconfirm
	sudo pacman -S spectacle --noconfirm
	sudo pacman -S timeshift --noconfirm
	flatpak install flathub com.google.Chrome -y
	flatpak install flathub org.gimp.GIMP -y
	flatpak install flathub org.qbittorrent.qBittorrent -y
	flatpak install flathub org.flameshot.Flameshot -y
	flatpak install flathub org.gnome.EasyTAG -y
	flatpak install flathub com.stremio.Stremio
	flatpak install flathub org.kde.gwenview -y
	flatpak install flathub org.kde.kcalc -y
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
	flatpak install flathub com.dec05eba.gpu_screen_recorder -y
	flatpak install flathub org.kde.okular -y
	echo -e ' All Arch Linux apps have been installed\n'

# Install flatpak Mangohud app
installs-mangohud:
	#!/bin/bash

	echo -e '\n Installing MangoHud overlay\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud
	echo -e ' Flatpak MangoHud app installed\n'

# Set up git and GitHub account
setup-github:
	#!/bin/bash

	echo -e '\n Generating a new SSH key\n'
	ssh-keygen -t ed25519 -C 13894059+Krauzer94@users.noreply.github.com
	echo -e '\n Copy the newly created key\n'
	cat ~/.ssh/id_ed25519.pub
	echo -e '\n Paste it into a new SSH key\n'
	flatpak run com.google.Chrome https://github.com/settings/keys
	echo -e ' Git setup finished\n'

# Install portable Neofetch app
installs-neofetch:
	#!/bin/bash

	echo -e '\n Setting up the Neofetch script\n'
	wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
	mv neofetch .neofetch.sh
	mv .neofetch.sh $HOME/
	echo -e ' Neofetch has finished installing\n'

# Set up flatpak permissions
setup-filesys:
	#!/bin/bash

	echo -e '\n Managing flatpak permissions\n'
	mkdir $HOME/.themes
	mkdir $HOME/.icons
	cp -r /usr/share/themes/* $HOME/.themes/
	cp -r /usr/share/icons/* $HOME/.icons/
	flatpak override --user --filesystem=$HOME/.themes
	flatpak override --user --filesystem=$HOME/.icons
	flatpak override --user --filesystem=$HOME/Music
	flatpak override --user --filesystem=$HOME/Games
	flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
	flatpak override --user --filesystem=xdg-config/MangoHud:ro
	echo -e ' Finished applying flatpak permissions\n'

# Upload savegame folder files
upload-savegame:
	#!/bin/bash

	git add .
	git commit -m "Save game upload"
	git push
