echo -e '\n Setting up Git for GitHub\n'
git config --global user.name "GITHUB_USER_NAME"
git config --global user.email "GITHUB_ENCRYPTED_USER_EMAIL"
git config --global init.defaultBranch main
git config --global color.ui auto
git config --global pull.rebase false
git config --global core.editor "com.visualstudio.code --wait"
ssh-keygen -t ed25519 -C GITHUB_USER_EMAIL
echo -e '\n Copy the newly generated key\n'
cat ~/.ssh/id_ed25519.pub
echo -e '\n Paste it into a new SSH key\n'
flatpak run com.google.Chrome https://github.com/settings/keys
echo -e '\n Git setup finished\n'
