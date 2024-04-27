## Just
Append this to `.bashrc`:
```bash
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
```

## Flatseal
 1. `xdg-config/gtk-3.0:ro`
 2. `xdg-config/MangoHud:ro`
 3. `~/Music`
 4. `~/Games`
 5. `MANGOHUD=1`
---

## Automount
1. Find device partition using **Partition Manager**;
2. Run the command after editing the `{PARTITION}`:
```bash
ls -la /dev/disk/by-id | grep {PARTITION}
```
3. Add it to `fstab` editing the `{DEVICE_UNIQUE_ID}`:
```bash
sudo mkdir /mnt/secondary
sudo sh -c 'echo -e "\n# Automount secondary drive\n{DEVICE_UNIQUE_ID} /mnt/secondary btrfs subvol=/,noatime,lazytime,commit=120,discard=async,compress-force=zstd:3,space_cache=v2,nofail 0 0" >> /etc/fstab'
sudo systemctl daemon-reload
sudo mount -a
```
---
