#!/bin/bash

INSTALL_DIR=/mnt/sda2

rm -r -f ~/PyLab && \
git clone git://github.com/gloveboxes/PyCon-Hands-on-Lab.git $INSTALL_DIR/PyLab && \
chmod +x $INSTALL_DIR/PyLab/Lab-setup/setup/*.sh