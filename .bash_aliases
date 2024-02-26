# Update and clean
alias update='flatpak update'
alias clean='flatpak uninstall --unused'

# Git routines
alias status='git status'
alias add0='git add .'
alias add1='git commit'
alias commit='add0 && add1'
alias push='git push'
alias log='git log -1'
alias pull0='git fetch'
alias pull1='git pull'
alias pull='pull0 && pull1'

# Other aliases
alias ll='ls -l'
alias shutdown='shutdown now'
alias flist='flatpak list --app'
alias flrun='flatpak list --runtime'
alias neofetch='bash $HOME/.neofetch.sh'
alias video='bash .video-editing.sh'
alias clip='bash .rescale-clips.sh'
alias code='flatpak run com.visualstudio.code'
alias save='bash $HOME/.dotfiles/save_upload.sh'
