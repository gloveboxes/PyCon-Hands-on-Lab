#!/bin/bash

rm -r ~/ftp/PyLab
mkdir -p ~/ftp/PyLab

cp -r ~/PyLab/Lab1-ssh-debug ~/ftp/PyLab
cp -r ~/PyLab/Lab2-docker-debug ~/ftp/PyLab

for i in {01..25}
do
    echo "Set up lab content for user dev$i"

    sudo rm -r -f /home/dev$i/PyLab
    sudo mkdir -p /home/dev$i/PyLab

    sudo cp -r ~/PyLab/Lab1-ssh-debug /home/dev$i/PyLab
    sudo cp -r ~/PyLab/Lab2-docker-debug /home/dev$i/PyLab

    sudo chown -R dev$i:dev$i /home/dev$i
done
