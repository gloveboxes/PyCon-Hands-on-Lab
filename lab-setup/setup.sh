sudo apt update && sudo apt install -y git python3-pip nmap libatlas-base-dev && \
sudo -H  pip3 install --upgrade pip && \
sudo -H pip3 install numpy pillow requests pandas flask bottle RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280 adafruit-circuitpython-sht31d paho-mqtt autopep8

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

sudo reboot

for i in {01..35}
do
    sudo useradd  -p $(openssl passwd -1 raspberry) dev$i -G i2c,users, docker -m
    echo "dev$i ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/010_pi-nopasswd
    sudo cp -R /home/pi/.vscode-server-insiders /home/dev$i/.vscode-server-insiders
    sudo chown -R dev$i:dev$i /home/dev$i/.vscode-server-insiders
    sudo mkdir -p /home/dev$i/github/mywebapp
    sudo cp /home/pi/source/bottle-app.py /home/dev$i/github/mywebapp/
    sudo cp /home/pi/source/flask-app.py /home/dev$i/github/mywebapp/
    sudo chown -R dev$i:dev$i /home/dev$i

    echo "export LAB_PORT=\$(shuf -i 5000-8000 -n 1)" >> /home/dev$i/.bashrc 
    echo "export LAB_HOST=\$(hostname -I)" >>  /home/dev$i/.bashrc
done
