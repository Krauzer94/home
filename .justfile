#import "/usr/share/ublue-os/justfile"

# User specific recipes list
default:
	just --list

# Fast data sharing pastebin
paste-rs:
	#!/bin/bash

	echo -e '\n Setting up the paste function\n'
	sudo sh -c 'echo -e "\n# paste.rs\nfunction paste() {\n    local file=${1:-/dev/stdin}\n    curl --data-binary @${file} https://paste.rs\n}" >> .bashrc'
	echo -e '\n paste function added to to .bashrc\n'

# User specific Bash aliases
alias-setup:
	#!/bin/bash

	echo -e '\n Setting up the Bash Aliases file\n'
	echo -e "\n# Bash aliases\nif [ -f ~/.bash_aliases ]; then\n. ~/.bash_aliases\nfi" >> .bashrc
	echo -e '\n Bash Aliases setup finished\n'

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
	echo -e '\n All Flatpak apps have been installed\n'

# Install Fedora specific apps
installs-fedora:
	#!/bin/bash

	echo -e '\n Installing all Flatpak apps\n'
	flatpak install flathub com.google.Chrome -y
	flatpak install flathub org.gimp.GIMP -y
	flatpak install flathub org.qbittorrent.qBittorrent -y
	flatpak install flathub org.videolan.VLC -y
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
	echo -e '\n All Flatpak apps have been installed\n'

# Install flatpak Mangohud app
installs-mangohud:
	#!/bin/bash

	echo -e '\n Installing MangoHud overlay\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud
	echo -e '\n Flatpak MangoHud app installed\n'

# Set up git and GitHub account
github-setup:
	#!/bin/bash

	echo -e '\n Generating a new SSH key\n'
	ssh-keygen -t ed25519 -C 13894059+Krauzer94@users.noreply.github.com
	echo -e '\n Copy the newly created key\n'
	cat ~/.ssh/id_ed25519.pub
	echo -e '\n Paste it into a new SSH key\n'
	flatpak run com.google.Chrome https://github.com/settings/keys
	echo -e '\n Git setup finished\n'

# Set up portable neofetch app
neofetch-dot:
	#!/bin/bash

	echo -e '\n Setting up the Neofetch script\n'
	wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
	mv neofetch .neofetch.sh
	echo -e '\n Neofetch has finished installing\n'

# Enable system theme for apps
perm-theme:
	#!/bin/bash

	echo -e '\n Managing the theme permissions\n'
	mkdir $HOME/.themes
	mkdir $HOME/.icons
	cp -r /usr/share/themes/* $HOME/.themes/
	cp -r /usr/share/icons/* $HOME/.icons/
	flatpak override --filesystem=$HOME/.themes
	flatpak override --filesystem=$HOME/.icons
	echo -e '\n Finished applying system themes\n'
# You can add your own commands here! For documentation, see: https://ublue.it/guide/just/
import "/usr/share/ublue-os/justfile"
