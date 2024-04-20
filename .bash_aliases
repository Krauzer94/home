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
alias neofetch='sh $HOME/.neofetch.sh'
alias code='flatpak run com.visualstudio.code'
alias save='sh $HOME/.dotfiles/save_upload.sh'

# Video editing
alias video='sh .video-editing.sh'
alias clip='sh .clips-editing.sh'
alias deck='sh .deck-twitter.sh'

# Dotfiles scripts
alias aliases-setup='sh $HOME/.dotfiles/aliases_setup.sh'
alias flatpak-apps='sh $HOME/.dotfiles/flatpak_apps.sh'
alias github-setup='sh $HOME/.dotfiles/github_setup.sh'
alias neofetch-dot='sh $HOME/.dotfiles/neofetch_dot.sh'
alias perm-theme='sh $HOME/.dotfiles/perm_theme.sh'
