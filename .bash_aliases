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
alias scale='bash .rescale-clips.sh'
alias code='flatpak run com.visualstudio.code'

# FFmpeg aliases
alias trim='ffmpeg -ss 10 -t 20 -i $HOME/Videos/2.mp4 -c copy $HOME/Videos/1.mp4'
alias fade='ffmpeg -i $HOME/Videos/1.mp4 -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' $HOME/Videos/0.mp4'
alias merge='ffmpeg -f concat -i $HOME/Videos/merge.txt -c copy $HOME/Videos/merged.mp4'
alias compress='ffmpeg -i $HOME/Videos/1.mp4 -vcodec libx265 -crf 28 $HOME/Videos/compressed.mp4'
alias rescale='ffmpeg -i $HOME/Videos/1.mp4 -vf "scale=1920:1080" $HOME/Videos/scaled.mp4'
