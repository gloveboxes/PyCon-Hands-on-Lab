sudo apt update && sudo apt install -y git python3-pip nmap && \
sudo -H pip3 install flask bottle RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280 adafruit-circuitpython-sht31d paho-mqttautopep8

sudo groupadd i2c && \
sudo chown :i2c /dev/i2c-1 && \
sudo chmod g+rw /dev/i2c-1

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
done
