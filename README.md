## Arch
Additional packages:
```bash
steam ffmpeg git mangohud packagekit-qt6 firefox flatpak spectacle timeshift fuse2
```

## `.bashrc`
#### just
```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
```

#### paste
```bash
# paste.rs
function paste() {
    echo ""
    local file=${1:-/dev/stdin}
    curl --data-binary @${file} https://paste.rs
    echo ""
    echo ""
}
```
---
