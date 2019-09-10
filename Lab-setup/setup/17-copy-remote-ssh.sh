#!/bin/bash

echo "After copy the Raspberry Pi will reboot"

for i in {01..25}
do
    echo "Deploy Remote SSH Server to user dev$i"
    sudo rm -r -f /home/dev$i/.vscode-server
    sudo cp -r /home/pi/.vscode-server /home/dev$i/.vscode-server
    sudo chown -R dev$i:dev$i /home/dev$i
done
