# Using a Pi 3A/B Plus as a Ethernet to WiFi router

* Date: **August 2019**
* Operating System: **Raspbian Buster**
* Kernel: **4.19**
* Acknowledgements: **This is based on the guide at [Using a Pi 3 as a Ethernet to WiFi router](https://medium.com/linagora-engineering/using-a-pi-3-as-a-ethernet-to-wifi-router-2418f0044819)**

## Update Raspberry Pi and Reboot

```bash
sudo apt update && sudo apt upgrade -y && sudo reboot
```

## Enable Packet Forwarding for IPv4 and Restart Service

```bash
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf && \
sudo sysctl -p
```

## Set static address for Raspberry Pi running the DHCP Server

Append network configuration to the /etc/dhcpcd.conf.

```bash
sudo cat <<EOT>> /etc/dhcpcd.conf
interface eth0
static ip_address=192.168.2.1/24
static domain_name_servers=8.8.8.8 8.8.4.4
noipv6
EOT
```

### Restart Ethernet Interface

```bash
sudo ifconfig eth0 down && sudo ifconfig eth0 up
```

## Install the DHCP Server

```bash
sudo apt-get install -y isc-dhcp-server && \
sudo service isc-dhcp-server stop
```

### Lock DHCP Services to the Ethernet adapter

We only want the DHCP Server to serve IP Addresses on the Ethernet adapter (not the wifi)

```bash
sed -i 's/INTERFACESv4=""/INTERFACESv4="eth0"/g' /etc/default/isc-dhcp-server
```


### Configure the DHCP Server Options

```bash
$ sudo nano /etc/dhcp/dhcpd.conf
```

Scroll through file and replace sample #authoritative section.

```
#authoritative;

authoritative; # I will be the single DHCP server on this network, trust me authoritatively
# subnet and netmask matches what you've defined on the network interface

subnet 192.168.2.0 netmask 255.255.255.0 {
  interface eth0; # Maybe optional, I was not sure :o

  range 192.168.2.50 192.168.2.250; # Hands addresses in this range
  option broadcast-address 192.168.2.255; # Matches the broadcast address of the network interface
  option routers  192.168.2.1; # The IP address of the Pi
  option domain-name "pycondebug.local"; # You can pick what you want here
  option domain-name-servers 8.8.8.8, 8.8.4.4; # Use your company DNS servers, or your home router, or any other DNS server
  default-lease-time 600;
  max-lease-time 7200;
}


```

## Routing traffic through the wireless interface, persist, and restart DHCP

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o wlan0 -j MASQUERADE && \
sudo apt install iptables-persistent && \
sudo systemctl restart isc-dhcp-server.service
```

## Turn off WiFi Power Management

Update /etc/rc.local for start on boot and turn off power management now.

```bash
sudo sed -i -e '$i \iwconfig wlan0 power off\n' /etc/rc.local && \
sudo iwconfig wlan0 power off
```

## SSH Authentication with private/public keys

![ssh login](resources/ssh-login.jpg)

### From Linux and macOS

1. Create your key. This is typically a one-time operation. **Take the default options**.

```bash
ssh-keygen -t rsa
```

2. Copy the public key to your Raspberry Pi.

```bash
ssh-copy-id pi@192.168.2.1
```

### From Windows

1. Use the built-in Windows 10 (1809+) OpenSSH client. Install the **OpenSSH Client for Windows** (one time only operation).

    From **PowerShell as Administrator**.

```bash
Add-WindowsCapability -Online -Name OpenSSH.Client
```

2. From PowerShell, create your key. This is typically a one-time operation. **Take the default options**

```bash
ssh-keygen -t rsa
```

3. From PowerShell, copy the public key to your Raspberry Pi

```bash
cat ~/.ssh/id_rsa.pub | ssh `
pi@192.168.2.1 `
"mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
```

## FYI DHCP Service Commands

```bash
$ sudo systemctl start isc-dhcp-server.service 
$ sudo systemctl stop isc-dhcp-server.service
$ sudo systemctl restart isc-dhcp-server.service  
$ sudo systemctl status isc-dhcp-server.service 
```

## Useful Tools

### Network Mapper

Scans network for active IP Addresses

```bash
$ sudo apt install nmap

$ nmap -sn 192.168.2.0/24
```