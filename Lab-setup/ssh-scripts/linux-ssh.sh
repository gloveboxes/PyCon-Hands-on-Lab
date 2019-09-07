#!/bin/bash

while true; do
    read -p "Enter Raspberry Pi Network IP Address: " PYLAB_IPADDRESS
    read -p "Enter your login name: " PYLAB_LOGIN
    read -p "Raspberry Pi Network Address '$PYLAB_IPADDRESS', login name '$PYLAB_LOGIN' Correct? ([Y]es,[N]o,[Q]uit): " yn
    case $yn in
        [Yy]* ) break;;
        [Qq]* ) exit 1;;
        [Nn]* ) continue;;
        * ) echo "Please answer yes(y), no(n), or quit(q).";;
    esac
done

PYLAB_SSHCONFIG=~/.ssh/config
PYLAB_TIME=$(date)

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

ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_python_lab
ssh-copy-id -i ~/.ssh/id_rsa_python_lab $PYLAB_LOGIN@$PYLAB_IPADDRESS

