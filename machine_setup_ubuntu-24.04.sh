#!/bin/bash

sudo apt -y update && sudo apt -y upgrade

sudo apt install net-tools snap ssh terminator git wget curl

sudo systemctl enable snapd ssh
sudo systemctl start snapd ssh

sudo snap install postman dbeaver-ce spotify
sudo snap install nvim --classic

cd ~

git init
git remote add origin https://github.com/SivaCn/dotfiles3.git
rm -rvf .bashrc .gitconfig

git checkout -b tmp origin/master
git branch -D master
git checkout -b master origin/master

# Clone the starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove the .git folder, so you can add it to your own repo later
rm -rf ~/.config/nvim/.git

sudo apt install dunst libnotify-bin

# Install Font Awesome (may need manual download)
wget -O fontawesome.zip https://use.fontawesome.com/releases/v6.4.0/fontawesome-free-6.4.0-desktop.zip
unzip fontawesome.zip -d fontawesome
sudo cp fontawesome/fontawesome-free-6.4.0-desktop/otfs/* /usr/local/share/fonts/
sudo fc-cache -f -v
