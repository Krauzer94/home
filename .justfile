_default:
	just --list

# Install common applications
installs-common:
	#!/bin/bash

	echo -e '\n Installing all common applications\n'
	just installs-neofetch
	just setup-filesys

	apps=(
		com.google.Chrome
		org.gimp.GIMP
		org.qbittorrent.qBittorrent
		org.flameshot.Flameshot
		org.gnome.EasyTAG
		com.stremio.Stremio
		org.bleachbit.BleachBit
		com.spotify.Client
		org.libretro.RetroArch
		org.onlyoffice.desktopeditors
		com.discordapp.Discord
		io.github.mimbrero.WhatsAppDesktop
		com.github.tchx84.Flatseal
		net.davidotek.pupgui2
		net.lutris.Lutris
		com.visualstudio.code
		com.dec05eba.gpu_screen_recorder
	)
	for app in "${apps[@]}"; do
		flatpak install flathub "$app" -y
	done

	echo -e '\n All common applications have been installed\n'

# Install SteamOS specific apps
installs-steamos:
	#!/bin/bash

	echo -e '\n Installing all SteamOS apps\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud
	just installs-common
	flatpak install flathub org.videolan.VLC -y
	echo -e '\n All SteamOS apps have been installed\n'

# Install GNOME specific apps
installs-gnome:
	#!/bin/bash

	echo -e '\n Installing all GNOME apps\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud

	packages=(
		git flatpak timeshift steam ffmpeg mangohud
		wayland-protocols noto-fonts noto-fonts-cjk
	)
	for package in "${packages[@]}"; do
		sudo pacman -S "$package" --noconfirm
	done

	sudo systemctl enable --now cronie.service bluetooth.service
	sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
	just installs-common
	flatpak install flathub org.videolan.VLC -y
	flatpak install flathub org.mozilla.firefox -y
	flatpak install flathub com.mattjakeman.ExtensionManager -y
	echo -e '\n All GNOME apps have been installed\n'

# Install Plasma specific apps
installs-plasma:
	#!/bin/bash

	echo -e '\n Installing all Plasma apps\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud

	packages=(
		git flatpak timeshift steam ffmpeg mangohud
		firefox spectacle packagekit-qt6 noto-fonts-cjk
	)
	for package in "${packages[@]}"; do
		sudo pacman -S "$package" --noconfirm
	done

	sudo systemctl enable --now cronie.service bluetooth.service NetworkManager.service
	just installs-common
	flatpak install flathub org.kde.okular -y
	flatpak install flathub org.kde.gwenview -y
	flatpak install flathub org.kde.kcalc -y
	echo -e '\n All Plasma apps have been installed\n'

# Set up git and GitHub account
setup-github:
	#!/bin/bash

	echo -e '\n Generating a new SSH key\n'
	ssh-keygen -t ed25519 -C 13894059+Krauzer94@users.noreply.github.com
	echo -e '\n Copy the newly created key\n'
	cat ~/.ssh/id_ed25519.pub
	echo -e '\n Paste it into a new SSH key: https://github.com/settings/keys\n'

# Install portable Neofetch app
installs-neofetch:
	#!/bin/bash

	echo -e '\n Setting up the Neofetch script\n'
	wget https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch
	mv neofetch .neofetch.sh
	mv .neofetch.sh $HOME/
	echo -e '\n Neofetch has finished installing\n'

# Set up flatpak permissions
setup-filesys:
	#!/bin/bash

	echo -e '\n Managing flatpak permissions\n'
	mkdir $HOME/.themes
	mkdir $HOME/.icons
	cp -r /usr/share/themes/* $HOME/.themes/
	cp -r /usr/share/icons/* $HOME/.icons/

	directories=(
		"$HOME/.themes"
		"$HOME/.icons"
		"$HOME/Music"
		"$HOME/Games"
		"xdg-config/gtk-3.0:ro"
		"xdg-config/MangoHud:ro"
	)
	for dir in "${directories[@]}"; do
		flatpak override --user --filesystem=$dir
	done

	echo -e '\n Finished applying flatpak permissions\n'

# Upload savegame folder files
upload-savegame:
	#!/bin/bash

	git add .
	git commit -m "Save game upload"
	git push

# Edit clips and keep the files
[no-cd]
edit-clips:
    #!/bin/bash

    # Rename clips
    counter=1
    for f in *.mp4; do
        mv "$f" "${counter}.mp4"
        ((counter++))
    done

    # Apply video effects
    apply_effects() {
        # Input and output
        f="$1"
        clip="clip-${f%.*}.${f##*.}"

        # Find video duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")

        # Find the last second
        start=$(awk -v dur="$duration" 'BEGIN { print dur - 1 }')

        # Apply fade effects
        ffmpeg -i "$f" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$start:d=1" \
        -af "afade=t=in:st=0:d=1,afade=t=out:st=$start:d=1" "$clip" -y && rm "$f"
    }

    # Edit all videos
    for f in *.mp4; do
        apply_effects "$f"
    done

# Edit clips and merge all files
[no-cd]
edit-videos:
    #!/bin/bash

    # Create intermediates
    counter=1
    for f in *.mp4; do
        ffmpeg -i "$f" -c copy "intermediate-${counter}.ts" && rm "$f"
        ((counter++))
    done

    # Filename array
    files=($(find . -type f -name "*.ts"))
    concat_list=$(printf "concat:%s|" "${files[@]}")
    concat_list=${concat_list%|}

    # Merge all videos
    ffmpeg -i "$concat_list" -c copy video.mp4

    # Delete intermediates
    for f in *.ts; do
        rm "$f"
    done
