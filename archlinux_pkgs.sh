#!/usr/bin/env bash

printing_3d=(blender inkscape openscad eigen)
shell=(fzf man tmux zsh)
inkscape_recommends=(pstoedit  python2-scour texlive-core python2-lxml uniconvertor)
dev_tools=(alacritty atom ctags devtools docker docker-compose git postgresql qt5-webkit vim yarn)
fonts=(ttf-dejavu)
gaming=(steam steam-native-runtime)
general=(chromium deja-dup dropbox firefox)
hp_printing=(hplip python-reportlab python-pyqt4 python-pyqt5 sane xsane)
media=(audacious gthumb minidlna sound-juicer libaacs libva-mesa-driver mesa-vdpau lib32-mesa-vdpau)
networking=(gnome-nettool inetutils nmap wget)
vlc=(vlc libmicrodns protobuf)
office=(libreoffice-fresh gimp simple-scan thunderbird)
qt_tools=(qt5-wayland)
system=(btrfs-progs dmidecode gufw lm_sensors mesa-demos nvme reflector smartmontools xdotool)
themes=(arc-gtk-theme arc-icon-theme)

printf 'Shell...'
sudo pacman -S ${shell[*]}

printf 'Dev tools and networking...\n'
sudo pacman -S ${dev_tools[*]} ${networking[*]}

printf 'Fonts...\n'
sudo pacman -S ${fonts[*]}

printf 'Gaming...\n'
sudo pacman -S ${gaming[*]}

printf 'General...\n'
sudo pacman -S ${general[*]}

printf '3D Printing...\n'
sudo pacman -S ${printing_3d[*]}

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
