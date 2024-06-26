_default:
	just --list

# Install SteamOS specific apps
installs-steamos:
	#!/bin/bash

	echo -e '\n Installing all SteamOS apps\n'
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
	echo -e '\n All SteamOS apps have been installed\n'

# Install Mint specific apps
installs-mint:
	#!/bin/bash

	echo -e '\n Installing all Linux Mint apps\n'
	sudo apt update
	sudo apt install steam -y
	sudo apt install ffmpeg -y
	sudo apt install git -y
	sudo apt install mangohud -y
	sudo apt install timeshift -y
	echo -e '\n All Linux Mint apps have been installed\n'

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
	sudo pacman -S nvidia-settings --noconfirm
	# sudo pacman -S sof-firmware --noconfirm
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
	flatpak install flathub org.kde.okular -y
	flatpak install flathub org.kde.gwenview -y
	flatpak install flathub org.kde.kcalc -y
	echo -e '\n All Arch Linux apps have been installed\n'

# Install flatpak Mangohud app
installs-mangohud:
	#!/bin/bash

	echo -e '\n Installing MangoHud overlay\n'
	flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud
	echo -e '\n Flatpak MangoHud app installed\n'

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
	flatpak override --user --filesystem=$HOME/.themes
	flatpak override --user --filesystem=$HOME/.icons
	flatpak override --user --filesystem=$HOME/Music
	flatpak override --user --filesystem=$HOME/Games
	flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
	flatpak override --user --filesystem=xdg-config/MangoHud:ro
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

    # # Upscale to 1080p
    # ffmpeg -i merged.mp4 -vf "scale=1920:1080" -c:v libx264 -crf 23 -preset veryfast video.mp4
    # rm merged.mp4

    # Delete intermediates
    for f in *.ts; do
        rm "$f"
    done
