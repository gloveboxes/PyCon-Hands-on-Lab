#!/bin/bash

rm -r -f ~/PyLab && \
git clone --depth=1 https://github.com/gloveboxes/PyCon-Hands-on-Lab.git ~/PyLab && \
sudo chmod +x ~/PyLab/Lab-setup/setup/*.sh && \
cd ~/PyLab/Lab-setup/setup