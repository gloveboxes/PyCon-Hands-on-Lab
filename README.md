# Raspberry Pi and Visual Studio Code Remote Dev over SSH

## Create up Lab Resources

[Setting I2C permissions for non-root users](https://lexruee.ch/setting-i2c-permissions-for-non-root-users.html)

```bash
sudo apt update && sudo apt install -y git python3-pip nmap && \
sudo -H pip3 install flask bottle RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280 autopep8

sudo groupadd i2c && \
sudo chown :i2c /dev/i2c-1 && \
sudo chmod g+rw /dev/i2c-1

for i in {01..35}
do
    sudo useradd  -p $(openssl passwd -1 raspberry) dev$i -G i2c,users -m
    echo "dev$i ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/010_pi-nopasswd
    sudo cp -R /home/pi/.vscode-server-insiders /home/dev$i/.vscode-server-insiders
    sudo chown -R dev$i:dev$i /home/dev$i/.vscode-server-insiders
    sudo mkdir -p /home/dev$i/github/mywebapp
    sudo cp /home/pi/source/bottle-app.py /home/dev$i/github/mywebapp/
    sudo cp /home/pi/source/flask-app.py /home/dev$i/github/mywebapp/
    sudo chown -R dev$i:dev$i /home/dev$i
done


for i in 'windows' 'macos' 'linux'
do
    # sudo useradd  -p $(openssl passwd -1 raspberry) $i -G i2c,users -m
    # echo "$i ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/010_pi-nopasswd
    # sudo cp -R /home/pi/.vscode-server-insiders /home/$i/.vscode-server-insiders
    # sudo chown -R $i:$i /home/$i/.vscode-server-insiders

    # sudo cp -R /home/pi/.vscode-server-insiders /home/windows/.vscode-server-insiders
    # sudo chown -R windows:windows /home/windows/.vscode-server-insiders


    for u in {01..35}
    do
        sudo mkdir -p /home/$i/github/dev-$u
        sudo cp /home/pi/github/main.py /home/$i/github/dev-$u
        sudo chown -R $i:$i /home/$i/github/dev-$u
    done
    # sudo mkdir -p /home/$i/github/mywebapp
    # sudo cp /home/pi/source/main.py /home/$i/github/mywebapp/
    # sudo chown -R $i:$i /home/$i
done
```

### Global Pip install required lab packages

```bash
sudo apt update && sudo apt install -y git python3-pip nmap && \
sudo -H pip3 install flask bottle RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280
```

## Clean up Lab Resources

```bash

for i in 'windows' 'macos' 'linux'
do
    sudo deluser $i
    sudo rm -r /home/$i
done


for i in {01..40}
do
    sudo deluser dev$i
done

sudo rm -r /home/dev*

echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010_pi-nopasswd
```

### Review No Passwords File

```bash
sudo visudo -f /etc/sudoers.d/010_pi-nopasswd
```
