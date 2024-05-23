## Arch
Additional packages:
```bash
steam ffmpeg git mangohud packagekit-qt6 firefox flatpak spectacle fuse2
```

## Just
Append to `.bashrc`:
```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
```

## paste.rs
Append to `.bashrc`:
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

## Flatseal
Global filesystem:
 1. `xdg-config/gtk-3.0:ro`
 2. `xdg-config/MangoHud:ro`
 3. `~/Music`
 4. `~/Games`
 5. `MANGOHUD=1`
---
