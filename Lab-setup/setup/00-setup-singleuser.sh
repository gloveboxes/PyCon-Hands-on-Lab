#!/bin/bash

~/PyLab/Lab-setup/setup/11-install-core.sh
if [ $? -ne 0 ]; then
    exit $?
fi

~/PyLab/Lab-setup/setup/12-refresh-PyLab.sh
~/PyLab/Lab-setup/setup/13-load-ftp.sh
~/PyLab/Lab-setup/setup/14-create-users.sh
~/PyLab/Lab-setup/setup/15-copy-lab.sh
~/PyLab/Lab-setup/setup/16-build-images.sh
~/PyLab/Lab-setup/setup/17-copy-remote-ssh.sh

sudo reboot