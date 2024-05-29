## `.bashrc`
### flatrun
```bash
# Use Name instead of ID for 'flatpak run'
function flatrun(){
    app_name="$@"
    app_id=$(flatpak list | grep -F -i "$app_name" | awk '{for(i=1;i<=NF;i++){ if($i ~ /\S+\.\S*/){print $i; break;} } }');
    flatpak run $app_id
}
```

### just
```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
```

### paste
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
