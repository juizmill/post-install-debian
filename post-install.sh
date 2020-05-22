#!/bin/bash

sudo su

echo ">>> ADD NAMESERVER GOOGLE <<<"
echo > /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo ">>> Edit Source List <<<"
mv /etc/apt/sources.list /etc/apt/sources.list-BKP
touch /etc/apt/sources.list
cat << EOF | tee -a /etc/apt/sources.list
deb [arch=amd64] http://ftp.br.debian.org/debian/ stable main contrib non-free
deb [arch=amd64] http://ftp.br.debian.org/debian/ stable-updates main contrib non-free
deb [arch=amd64] http://security.debian.org/ stable/updates main contrib non-free
EOF

echo ">>> Install Vim and bash-completion<<<"
apt install vim -y
apt install bash-completion

echo ">>> Update and upgrade <<<"
apt update -y
apt upgrade -y

echo ">>> Install flatpak and snapd <<<"
apt install flatpak -y
apt install snapd -y

echo ">>> Install codec <<<"
apt install libavcodec-extra -y

echo ">>> Install Development Tool <<<"
snap install sublime-text --classic
snap install code --classic
snap install dbeaver-ce
snap install insomnia
flatpak install flathub org.filezillaproject.Filezilla

echo ">>> Configure Interface <<<"
# https://www.gnome-look.org/p/1316887/
apt install gnome-tweak-tool
