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
alias fetch='git fetch'
alias pull='git pull'

# Other aliases
alias ll='ls -l'
alias shutdown='shutdown now'
alias flist='flatpak list --app'
alias flrun='flatpak list --runtime'
alias neofetch='bash $HOME/.neofetch.sh'
alias video='bash .video-editing.sh'
alias clip='bash .clips-editing.sh'
alias fade='bash .clips-effects.sh'
alias code='flatpak run com.visualstudio.code'
alias save='bash $HOME/.dotfiles/save_upload.sh'
