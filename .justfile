_default:
	just --list

# User specific Bash aliases
setup-aliases:
	#!/bin/bash

	echo -e '\n Setting up the Bash Aliases file\n'
	echo -e "\n# Bash aliases\nif [ -f ~/.bash_aliases ]; then\n. ~/.bash_aliases\nfi" >> ~/.bashrc
	echo -e ' Bash Aliases setup finished\n'

# Install SteamOS specific apps
installs-steamos:
	#!/bin/bash

	echo -e '\n Installing all Flatpak apps\n'
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
	echo -e ' All Flatpak apps have been installed\n'

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
	echo -e ' All Flatpak apps have been installed\n'

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

# Enable system theme for apps
setup-theming:
	#!/bin/bash

	echo -e '\n Managing the theme permissions\n'
	mkdir $HOME/.themes
	mkdir $HOME/.icons
	cp -r /usr/share/themes/* $HOME/.themes/
	cp -r /usr/share/icons/* $HOME/.icons/
	flatpak override --user --filesystem=$HOME/.themes
	flatpak override --user --filesystem=$HOME/.icons
	echo -e ' Finished applying system themes\n'

# Upload savegame folder files
upload-savegame:
	#!/bin/bash

	git add .
	git commit -m "Save game upload"
	git push
