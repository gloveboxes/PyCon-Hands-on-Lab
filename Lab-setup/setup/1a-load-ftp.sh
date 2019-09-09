#!/bin/bash

rm -r -f ~/PyLab && \
git clone https://github.com/gloveboxes/PyCon-Hands-on-Lab.git ~/PyLab && \
sudo chmod +x ~/PyLab/Lab-setup/setup/*.sh

# Download Lab software
rm -r -f ~/ftp/*
mkdir -p ~/ftp/software/linux
mkdir -p ~/ftp/software/macos
mkdir -p ~/ftp/software/windows
mkdir -p ~/ftp/ssh-setup
mkdir -p ~/ftp/PyLab

echo 'downloading Visual Studio Code for Ubuntu starting'
cd ~/ftp/software/linux
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkID=760868
mv index.html?LinkID=760868 code_1.38.0-1567547996_amd64.deb

wget  https://go.microsoft.com/fwlink/?LinkID=760867
mv index.html?LinkID=760867 code-1.38.0-1567548134.el7.x86_64.rpm

wget  https://go.microsoft.com/fwlink/?LinkID=620884
mv index.html?LinkID=620884 code-stable-1567547931.tar.gz

echo 'downloading Visual Studio Code for Windows starting'
cd ~/ftp/software/windows
rm * -f

wget  https://aka.ms/win32-x64-user-stable
mv win32-x64-user-stable VSCodeUserSetup-x64-1.38.0.exe

echo 'downloading Visual Studio Code for macOS starting'
cd ~/ftp/software/macos
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkID=620882
mv index.html?LinkID=620882 VSCode-darwin-stable.zip

echo "Copy SSH Scripts"
cp  ~/PyLab/Lab-setup/ssh-scripts/* ~/ftp/ssh-setup

