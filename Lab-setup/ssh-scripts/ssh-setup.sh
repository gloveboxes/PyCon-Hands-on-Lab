#!/bin/bash

echo
echo 'Purpose: This utility creates an SSH key, copies the public key to the Raspberry Pi, and updates the OpenSSH config file.'
echo 'Platform: Windows 7, 8, and 10.'
echo 'Version: 1.0, September 2019'
echo 'Author: Dave Glover, http://github.com/gloveboxes'
echo 'Licemce: MIT. Free to use, modify, no liability accepted'
echo
echo

BC=$'\e[30;48;5;82m'
EC=$'\e[0m'

while true; do
    read -p "Enter Raspberry Pi Network IP Address: " PYLAB_IPADDRESS
    read -p "Enter your login name: " PYLAB_LOGIN
    read -p "Raspberry Pi Network Address ${BC}$PYLAB_IPADDRESS${EC}, login name ${BC}$PYLAB_LOGIN${EC} Correct? ([Y]es,[N]o,[Q]uit): " yn
    case $yn in
        [Yy]* ) break;;
        [Qq]* ) exit 1;;
        [Nn]* ) continue;;
        * ) echo "Please answer yes(y), no(n), or quit(q).";;
    esac
done

PYLAB_SSHCONFIG=~/.ssh/config
PYLAB_TIME=$(date)

if [ ! -d "~/.ssh" ]; then
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
fi

echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo "Updating SSH Config file $PYLAB_SSHCONFIG"
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

echo >> $PYLAB_SSHCONFIG
echo "#Begin-PyLab $PYLAB_TIME" >> $PYLAB_SSHCONFIG
echo "Host pylab-$PYLAB_LOGIN" >> $PYLAB_SSHCONFIG
echo "    HostName $PYLAB_IPADDRESS" >> $PYLAB_SSHCONFIG
echo "    User $PYLAB_LOGIN" >> $PYLAB_SSHCONFIG
echo "    IdentityFile ~/.ssh/id_rsa_python_lab" >> $PYLAB_SSHCONFIG
echo "#End-PyLab" >> $PYLAB_SSHCONFIG
echo >> $PYLAB_SSHCONFIG

echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Generating SSH Key file ~/.ssh/id_rsa_python_lab"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo

ssh-keygen -t rsa -N "" -b 4096 -f ~/.ssh/id_rsa_python_lab

echo
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo 'Copying SSH Public Key to the Raspberry Pi'
echo
echo -e '\e[30;48;5;82mAccept continue connecting: type yes \e[0m'
echo -e '\e[30;48;5;82mThe Raspberry Pi Password is raspberry \e[0m'
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo

ssh-copy-id -i ~/.ssh/id_rsa_python_lab $PYLAB_LOGIN@$PYLAB_IPADDRESS
