echo -e '\n Generating a new SSH key\n'
ssh-keygen -t ed25519 -C 13894059+Krauzer94@users.noreply.github.com
echo -e '\n Copy the newly created key\n'
cat ~/.ssh/id_ed25519.pub
echo -e '\n Paste it into a new SSH key\n'
flatpak run com.google.Chrome https://github.com/settings/keys
echo -e '\n Git setup finished\n'
