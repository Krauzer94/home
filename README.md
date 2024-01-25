# Testing

## Flatseal
 1. `xdg-config/gtk-3.0:ro`
 2. `xdg-config/MangoHud:ro`
 3. `~/Music`
 4. `~/Games`
 5. `MANGOHUD=1`
---

## NVIDIA
1. Run the command: `sudo nvidia-settings`
2. Enable "Force Full Composition Pipeline";
3. Save with "Save to X Configuration File";
---

## VS Code
1. Add the repository source:
```bash
sudo touch /etc/yum.repos.d/vscode.repo
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> /etc/yum.repos.d/vscode.repo'
```
2. Install Visual Studio Code:
```bash
rpm-ostree install code -y
```
3. Reboot
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
