#!/bin/bash

sudo rm -r -f ~/github && \
git clone --depth 1 https://github.com/gloveboxes/PyCon-Hands-on-Lab.git ~/github && \

for i in {01..25}
do
    echo "Set up lab content for user dev$i"
    sudo rm -r -f /home/dev$i/PyLab
    sudo cp -r ~/github/Lab1-ssh-debug /home/dev$i/PyLab
    sudo cp -r ~/github/Lab2-docker-debug /home/dev$i/PyLab
    sudo chown -R dev$i:dev$i /home/dev$i
done
