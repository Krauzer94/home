
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

# Other aliases
  alias ll='ls -l'
  alias shutdown='shutdown now'
  alias aliases='flatpak run com.visualstudio.code .bash_aliases'
  alias hud='kwrite $HOME/.config/MangoHud/MangoHud.conf'
  alias code='flatpak run com.visualstudio.code'
  alias flist='flatpak list --app'
  alias flrun='flatpak list --runtime'
  alias neofetch='bash .neofetch.sh'
  alias video='bash .video-editing.sh'

# FFmpeg aliases
  alias trim='ffmpeg -ss 10 -i $HOME/Videos/2.mp4 -t 20 -c copy $HOME/Videos/1.mp4'
  alias fade='ffmpeg -i $HOME/Videos/1.mp4 -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' $HOME/Videos/0.mp4'
  alias compress='ffmpeg -i $HOME/Videos/1.mp4 -vcodec libx265 -crf 28 $HOME/Videos/0.mp4'
  alias merge='ffmpeg -f concat -i $HOME/Videos/merge.txt -c copy $HOME/Videos/merged.mp4'
  alias scale='ffmpeg -i $HOME/Videos/3.mp4 -vf "scale=1280:720" $HOME/Videos/800.mp4'
