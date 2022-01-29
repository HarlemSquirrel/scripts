#!/usr/bin/env bash

printing_3d=(blender cura cura-resources-materials cura-binary-data inkscape openscad eigen)
shell=(fzf man tmux zsh)
inkscape_recommends=(pstoedit  python2-scour texlive-core python2-lxml uniconvertor)
dev_tools=(alacritty atom ctags devtools docker docker-compose git postgresql qt5-webkit vim yarn)
desktop_tools=(flameshot)
fonts=(noto-fonts noto-fonts-emoji ttf-dejavu)
gaming=(steam steam-native-runtime)
general=(chromium deja-dup dropbox firefox)
gnome_pks=(arc-gtk-theme arc-icon-theme xdg-desktop-portal-gtk)
kde_pkgs=(kdeconnect kde-gtk-config konsole packagekit-qt5 plasma-systemmonitor plasma-wayland-session)
hp_printing=(hplip python-reportlab python-pyqt4 python-pyqt5 sane xsane)
media=(audacious gthumb minidlna sound-juicer libaacs libva-mesa-driver mesa-vdpau lib32-mesa-vdpau)
networking=(gnome-nettool inetutils nmap wget)
vlc=(vlc libmicrodns protobuf)
office=(libreoffice-fresh gimp simple-scan)
qt_tools=(qt5-wayland)
system=(btrfs-progs dmidecode htop gufw lm_sensors mesa-demos nvme radeontop reflector smartmontools xdotool)


printf '==> Shell...'
sudo pacman -S ${shell[*]}

printf '==> Dev tools and networking...\n'
sudo pacman -S ${dev_tools[*]} ${networking[*]}

printf '==> Fonts...\n'
sudo pacman -S ${fonts[*]}

printf '==> Gaming...\n'
sudo pacman -S ${gaming[*]}

printf '==> General...\n'
sudo pacman -S ${general[*]}

printf '==> 3D Printing...\n'
sudo pacman -S ${printing_3d[*]}

read -n 1 -t 60 -p "Install HP printing packages? (y/N) " hp_printing_option;
case $hp_printing_option in
  y|Y)
    printf '==> HP Printing...\n'
    sudo pacman -S ${hp_printing[*]};;
  *)
    printf '==> Skipping HP Printing...\n';;
esac

printf '==> Media...\n'
sudo pacman -S ${media[*]} ${inkscape_recommends[*]} ${vlc[*]}

printf '==> Office...\n'
sudo pacman -S ${office[*]}

printf '==> System and qt...\n'
sudo pacman -S ${system[*]} ${qt_tools[*]}

case $XDG_CURRENT_DESKTOP in
  KDE)
    printf '==> KDE...\n'
    sudo pacman -S ${kde_pkgs[*]};;
  GNOME)
    printf '==> GNOME...\n'
    sudo pacman -S ${gnome_pks[*]};;
esac

printf "\n 🍻 Done! 🍻\n"
