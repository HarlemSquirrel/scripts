#!/usr/bin/env bash

3d_printing=(blender inkscape openscad eigen)
cli=(fzf zsh)
inkscape_recommends=(pstoedit  python2-scour texlive-core python2-lxml uniconvertor)
dev_tools=(atom ctags docker docker-compose git gnome-nettool nmap postgresql phantomjs qt5-webkit terminator vim yarn)
fonts=(ttf-dejavu)
gaming=(steam steam-native-runtime)
general=(chromium deja-dup dropbox firefox)
hp_printing=(hplip python-reportlab python-pyqt4 python-pyqt5 sane xsane)
media=(audacious minidlna sound-juicer libaacs libva-mesa-driver mesa-vdpau lib32-mesa-vdpau)
vlc=(vlc libmicrodns protobuf)
office=(libreoffice-fresh gimp simple-scan thunderbird)
qt_tools=(qt5-wayland)
system=(lm_sensors mesa-demos gufw smartmontools xdotool)
themes=(arc-gtk-theme)

printf 'CLI'
sudo pacman -S ${cli[*]}

printf 'Dev tools ...\n'
sudo pacman -S ${dev_tools[*]}

printf 'Fonts...\n'
sudo pacman -S ${fonts[*]}

printf 'Gaming...\n'
sudo pacman -S ${gaming[*]}

printf 'General...\n'
sudo pacman -S ${general[*]}

printf 'HP Printing...\n'
sudo pacman -S ${hp_printing[*]}

printf 'Media...\n'
sudo pacman -S ${media[*]} ${inkscape_recommends[*]} ${vlc[*]}

printf 'Office...\n'
sudo pacman -S ${office[*]}

printf 'System and qt...\n'
sudo pacman -S ${system[*]} ${qt_tools[*]}

printf 'Themes...\n'
sudo pacman -S ${themes[*]}
