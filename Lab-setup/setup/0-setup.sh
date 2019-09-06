#!/bin/bash

~/PyLab/Lab-setup/setup/1-install-core.sh
if [ $? -ne 0 ]; then
    exit $?
fi

~/PyLab/Lab-setup/setup/1a-load-ftp.sh
~/PyLab/Lab-setup/setup/2-create-users.sh
~/PyLab/Lab-setup/setup/3-copy-lab.sh
~/PyLab/Lab-setup/setup/4-build-images.sh
# ~/PyLab/Lab-setup/setup/5-copy-remote-ssh.sh

# sudo reboot