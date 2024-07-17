# Update and clean
alias fupdate='flatpak update -y'
alias fclean='flatpak uninstall --unused'
alias supdate='sudo pacman -Syu --noconfirm'
alias sclean='sudo pacman -Rns $(pacman -Qtdq)'

# Git routines
alias status='git status'
alias add0='git add .'
alias add1='git commit'
alias commit='add0 && add1'
alias push='git push'
alias log='git log -1'
alias fetch='git fetch'
alias pull='git pull'

# Other aliases
alias ll='ls -l --color=auto'
alias shutdown='shutdown now'
alias flist='flatpak list --app'
alias flrun='flatpak list --runtime'
alias neofetch='bash ~/.neofetch.sh'
alias code='flatpak run com.visualstudio.code'
alias save='just upload-savegame'

# Video editing
alias video='just edit-videos'
alias clip='just edit-clips'
