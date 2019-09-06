# Python Hands-on Labs Set Up

<!-- [Setting up Ethernet Access Point](wifirouter.md) -->

[OpenWRT and the Linksys WRT 1900 ACS Router](https://github.com/gloveboxes/Linksys-WRT-1900-ACS-with-Huawei-E3372-Hi-Link-LTE-Dongle)

## Raspberry Pi Sense HAT

**Remove Raspberry Pi Sense HAT**

Raspberry Pi Buster Lite will not boot with the Raspberry Pi Sense HAT attached. Attach the Raspberry Pi Sense HAT after running the set up scripts.

## Update Raspberry Pi

```bash
sudo apt update && sudo apt upgrade -y && sudo reboot
```

## Booting from a USB 3 Flash or SSD Drive

1. Plug in your USB 3 drive, then list your drives. If you only plugged in one USB drive then it's highly likely your drive with be /dev/sda.

    ```bash
    sudo fdisk -l
    ```

2. Delete existing partitions and create a new primary partition on the USB drive.

    ```bash
    sudo fdisk /dev/sda
    ```

    **fdisk commands**

    - p = print partitions
    - d = delete a partition
    - n = new partition - create a primary partition
    - w = write the partition information to disk

3. Format the newly created partition

    ```bash
    sudo mkfs.ext4 /dev/sda1
    ```

4. Create a mount point, mount the USB 3 drive, copy the Operating System files to the USB drive, and amend the cmdline.txt to enable booting from the USB 3 drive

    ```bash
    sudo mkdir /media/usbdrive && \
    sudo mount /dev/sda1 /media/usbdrive && \
    sudo rsync -avx / /media/usbdrive && \
    sudo sed -i '$s/$/ root=\/dev\/sda1 rootfstype=ext4 rootwait/' /boot/cmdline.txt && \
    sudo reboot
    ```

## Install the Fan SHIM Software

[Fan SHIM](https://shop.pimoroni.com/products/fan-shim) installation.

```bash
sudo apt install -y git sudo python3-pip vsftpd && \
git clone https://github.com/pimoroni/fanshim-python && \
cd fanshim-python && \
sudo ./install.sh && \
cd examples && \
sudo ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 2
```

## Clone PyLab to the Raspberry Pi

Login to the Raspberry Pi and run the following commands.

```bash
sudo rm -r -f ~/PyLab && \
git clone https://github.com/gloveboxes/PyCon-Hands-on-Lab.git ~/PyLab && \
sudo chmod +x ~/PyLab/Lab-setup/setup/*.sh
```

## End to End Set Up

Running this script will set up the PyLab lab **except** for the Remote SSH Components that must be installed separately (see next step).

```bash
~/PyLab/Lab-setup/setup/0-setup.sh
```

## Install Remote SSH on the Raspberry Pi

It is critical that Lab attendees install the same version of VS Code (from the FTP Server) so it matches the VS Code Server Components installed on the Raspberry Pi. Otherwise 200MB per User will be downloaded when they start a Remote SSH Session.

From your desktop:

1. From your internet browser, link to **ftp://\<raspberry pi name>.local**, download and install Visual Studio Code Insiders.

2. Install Remote SSH and Python Extensions

    ```bash
    code-insiders --install-extension ms-vscode-remote.remote-ssh
    code-insiders --install-extension ms-python.python
    ```

3. Start Visual Studio Code Insiders
4. Start Remote SSH to the Raspberry Pi. This will install the Remote SSH Components on the Raspberry Pi. Add an SSH config:

    ```
    Host raspberrypi
        HostName <Raspberry Pi Name>.local
        User pi
    ```

5. Enabled the Python Extension on SSH
6. Close Remote SSH Connection to the Raspberry Pi
7. **Reboot the Raspberry Pi to make sure all files and locks closed**

### Deploy Remote SSH Server  to all users

Login to the Raspberry Pi and running the following command.

```bash
~/PyLab/Lab-setup/setup/5-copy-remote-ssh.sh
```

## Installing PyLab Components Manually

You can also run each component manually.

### Install Core Libraries

```bash
~/PyLab/Lab-setup/setup/1-install-core.sh
```

### Create Users

```bash
~/PyLab/Lab-setup/setup/2-create-users.sh
```

### Deploy Lab Content to all users

```bash
~/PyLab/Lab-setup/setup/3-copy-lab.sh
```

### Build Lab Docker Images

```bash
~/PyLab/Lab-setup/setup/4-build-images.sh
```

### Clean Up Lab

Delete all devNN users and remove files and reset nopasswd

```bash
~/PyLab/Lab-setup/setup/6-cleanup-lab.sh
```

## Useful Commands

### Raspberry Pi CPU Temperature

```bash
watch vcgencmd measure_temp

```

### Holding back VS Code Insiders Updates

[How to prevent updating of a specific package?](https://askubuntu.com/questions/18654/how-to-prevent-updating-of-a-specific-package)

**apt**

Hold a package:

```bash
sudo apt-mark hold code-insiders
```

Remove the hold:

```bash
sudo apt-mark unhold code-insiders
```

Show all packages on hold:

```bash
sudo apt-mark showhold
```
