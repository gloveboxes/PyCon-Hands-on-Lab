#!/bin/bash

while true; do
    read -p "Name your Raspberry Pi: " RPI_NAME
    read -p "You wish to name your Raspberry Pi '$RPI_NAME'. Correct? (Yes/No/Quit)" yn
    case $yn in
        [Yy]* ) break;;
        [Qq]* ) exit;;
        [Nn]* ) continue;;
        * ) echo "Please answer yes(y), no(n), or quit(q).";;
    esac
done

# Rename Raspberry Pi
sudo sed -i "s/raspberrypi/$RPI_NAME/g" /etc/hostname
sudo sed -i "s/raspberrypi/$RPI_NAME/g" /etc/hosts

# Install required libraries
sudo apt install -y git python3-pip nmap bmon libatlas-base-dev libopenjp2-7 libtiff5
export PIP_DEFAULT_TIMEOUT=200 
sudo pip3 install --upgrade pip
sudo -H pip3 install numpy pillow requests pandas matplotlib flask jupyter autopep8 pylint azure-cosmosdb-table

# Install Docker
# Links valid as of August 2019
# https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf

curl -sSL get.docker.com | sh && sudo usermod pi -aG docker

# wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb
# wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_19.03.2~3-0~debian-buster_armhf.deb
# wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_19.03.2~3-0~debian-buster_armhf.deb

# sudo dpkg -i containerd.io*
# sudo dpkg -i docker-ce-cli*
# sudo dpkg -i docker-ce_*
# sudo usermod -aG docker $USER

## Allow all to have access to I2C
# sudo groupadd i2c
sudo chown :i2c /dev/i2c-1
sudo chmod g+rw /dev/i2c-1

sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

# Patch for Raspberry Pi Sense Hat on Buster Headless/lite
sudo sed -i 's/#hdmi_force_hotplug=1/hdmi_force_hotplug=1/g' /boot/config.txt
sudo sed -i 's/#hdmi_group=1/hdmi_group=2/g' /boot/config.txt
sudo sed -i 's/#hdmi_mode=1/hdmi_mode=4/g' /boot/config.txt

# Enable I2C
sudo sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/config.txt

# Set GPU Memory from defaul of 64 to 16
sudo sed -i 's/gpu_mem=64/gpu_mem=16/g' /boot/config.txt

# Set up Very Secure FTP Daemon
mkdir -p /home/pi/ftp
sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.backup
echo "listen_ipv6=YES" | sudo tee -a /etc/vsftpd.conf
echo "anonymous_enable=YES" | sudo tee -a /etc/vsftpd.conf
echo "anon_root=/home/pi/ftp" | sudo tee -a /etc/vsftpd.conf
echo "local_umask=022" | sudo tee -a /etc/vsftpd.conf

# Download Lab software
mkdir -p /home/pi/ftp/ubuntu-pylab
mkdir -p /home/pi/ftp/macos-pylab
mkdir -p /home/pi/ftp/windows-pylab
mkdir -p /home/pi/ftp/PyLab

echo 'downloading Visual Studio Code Insiders for Ubuntu starting'
cd /home/pi/ftp/ubuntu-pylab
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkID=760865
mv index.html?LinkID=760865 ubuntu-code-insiders-amd64.deb

echo 'downloading Visual Studio Code Insiders for Windows starting'
cd /home/pi/ftp/windows-pylab
rm * -f

wget  https://aka.ms/win32-x64-user-insider
mv win32-x64-user-insider windows-code-insiders-amd64.exe
wget https://github.com/PowerShell/PowerShell/releases/download/v6.2.2/PowerShell-6.2.2-win-x64.msi

echo 'downloading Visual Studio Code Insiders for macOS starting'
cd /home/pi/ftp/macos-pylab
rm * -f

wget  https://go.microsoft.com/fwlink/?LinkId=723966
mv index.html?LinkId=723966 macOS-code-insiders-amd64.zip

echo 'Clone of PyLab starting'
cd /home/pi/ftp

echo 'Copy Lab projects to FTP Folder'
cp -r ~/PyLab/Lab1-ssh-debug ~/ftp/PyLab
cp -r ~/PyLab/Lab2-docker-debug ~/ftp/PyLab

echo "Copy SSH Scripts"
cp  ~/PyLab/Lab-setup/ssh-scripts/win* ~/ftp/windows-pylab

cp  ~/PyLab/Lab-setup/ssh-scripts/macos* ~/ftp/macos-pylab
sudo chmod +x ~/ftp/macos-pylab/*.sh

cp  ~/PyLab/Lab-setup/ssh-scripts/ubuntu* ~/ftp/ubuntu-pylab
sudo chmod +x ~/ftp/ubuntu-pylab/*.sh

echo '++++++++++++++++++++++++++++++++++++'
echo "login as ssh pi@$RPI_NAME.local"
echo '++++++++++++++++++++++++++++++++++++'

# sudo reboot