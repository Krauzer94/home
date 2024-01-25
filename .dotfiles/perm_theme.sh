echo -e '\n Managing the theme permissions\n'
mkdir $HOME/.themes
mkdir $HOME/.icons
cp -r /usr/share/themes/* $HOME/.themes/
cp -r /usr/share/icons/* $HOME/.icons/
flatpak override --filesystem=$HOME/.themes
flatpak override --filesystem=$HOME/.icons
echo -e '\n Finished applying system themes\n'
