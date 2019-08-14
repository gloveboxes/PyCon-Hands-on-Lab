# Python Hands-on Labs Set Up

[Setting up Ethernet Access Point](wifirouter.md)

## Visual Studio Code Remote Extensions

Start VS Code Insiders

SSH in as user **pi**

Install:

1. remote SSH
2. Python (on remote SSH)

## Update Raspberry Pi

```bash
sudo apt update && sudo apt upgrade -y && sudo reboot
```

## Change Raspberry Pi Default Password for pi

```bash
passwd
```

## Set Raspberry Pi Interface Options

Enable:

1. I2C
1. VNV

```bash
sudo raspi-config
```

## Install Core Libraries

```bash
sudo apt install -y git python3-pip nmap libatlas-base-dev && \
sudo pip3 install --upgrade pip && \
sudo -H pip3 install numpy pillow requests pandas flask bottle RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280 adafruit-circuitpython-sht31d paho-mqtt autopep8 pylint

# Install Docker
# Links valid as of August 2019
# https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf

wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/containerd.io_1.2.6-3_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce-cli_19.03.1~3-0~debian-buster_armhf.deb
wget https://download.docker.com/linux/debian/dists/buster/pool/stable/armhf/docker-ce_19.03.1~3-0~debian-buster_armhf.deb

sudo dpkg -i containerd.io* && \
sudo dpkg -i docker-ce-cli* && \
sudo dpkg -i docker-ce_* && \
sudo usermod -aG docker $USER && \


sudo groupadd i2c && \
sudo chown :i2c /dev/i2c-1 && \
sudo chmod g+rw /dev/i2c-1

sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile && \
sudo /etc/init.d/dphys-swapfile stop && \
sudo /etc/init.d/dphys-swapfile start

sudo reboot
```

## Create Users

**This should be a one time operation**

```bash
for i in {01..25}
do
    sudo useradd  -p $(openssl passwd -1 raspberry) dev$i -G i2c,users,docker -m
    echo "dev$i ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/010_pi-nopasswd

    echo 'export LAB_PORT=$(shuf -i 5000-8000 -n 1)' | sudo tee -a /home/dev$i/.bashrc
    echo 'export LAB_HOST=$(hostname -I | cut -d" " -f 1)' | sudo tee -a /home/dev$i/.bashrc
done

```

## Deploy Lab Content to all users

```bash
sudo rm -r ~/github
git clone --depth 1 https://github.com/gloveboxes/PyCon-Hands-on-Lab.git ~/github

for i in {01..25}
do
    echo "Set up lab content for user dev$i"
    sudo rm -r /home/dev$i/.vscode-server-insiders
    sudo rm -r /home/dev$i/github
    sudo cp -r /home/pi/.vscode-server-insiders /home/dev$i/.vscode-server-insiders
    sudo cp -r /home/pi/github /home/dev$i/github
    sudo chown -R dev$i:dev$i /home/dev$i
done

```

## Clean Up Lab

Delete all devNN users and remove files and reset nopasswd

```bash
for i in {01..25}
do
    sudo deluser dev$i
done

echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010_pi-nopasswd && \
sudo rm -r /home/dev*

```

## Useful Commands

### Raspberry Pi CPU Temperature

```bash
watch vcgencmd measure_temp

```
