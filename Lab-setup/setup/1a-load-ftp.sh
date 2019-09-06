#!/bin/bash

# Download Lab software
rm -r -f ~/ftp/*
mkdir -p /home/pi/ftp/linux-pylab
mkdir -p /home/pi/ftp/macos-pylab
mkdir -p /home/pi/ftp/windows-pylab
mkdir -p /home/pi/ftp/PyLab

echo 'downloading Visual Studio Code for Ubuntu starting'
cd /home/pi/ftp/linux-pylab
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkID=760868
mv index.html?LinkID=760868 code_1.38.0-1567547996_amd64.deb

wget  https://go.microsoft.com/fwlink/?LinkID=760867
mv index.html?LinkID=760867 code-1.38.0-1567548134.el7.x86_64.rpm

wget  https://go.microsoft.com/fwlink/?LinkID=620884
mv index.html?LinkID=620884 code-stable-1567547931.tar.gz

echo 'downloading Visual Studio Code for Windows starting'
cd /home/pi/ftp/windows-pylab
rm * -f

wget  https://aka.ms/win32-x64-user-stable
mv win32-x64-user-stable VSCodeUserSetup-x64-1.38.0.exe
wget https://github.com/PowerShell/PowerShell/releases/download/v6.2.2/PowerShell-6.2.2-win-x64.msi

echo 'downloading Visual Studio Code for macOS starting'
cd /home/pi/ftp/macos-pylab
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkID=620882
mv index.html?LinkID=620882 VSCode-darwin-stable.zip

echo 'Clone of PyLab starting'
cd /home/pi/ftp

echo 'Copy Lab projects to FTP Folder'
cp -r ~/PyLab/Lab1-ssh-debug ~/ftp/PyLab
cp -r ~/PyLab/Lab2-docker-debug ~/ftp/PyLab

echo "Copy SSH Scripts"
cp  ~/PyLab/Lab-setup/ssh-scripts/win* ~/ftp/windows-pylab

cp  ~/PyLab/Lab-setup/ssh-scripts/macos* ~/ftp/macos-pylab
sudo chmod +x ~/ftp/macos-pylab/*.sh

cp  ~/PyLab/Lab-setup/ssh-scripts/linux* ~/ftp/linux-pylab
sudo chmod +x ~/ftp/linux-pylab/*.sh