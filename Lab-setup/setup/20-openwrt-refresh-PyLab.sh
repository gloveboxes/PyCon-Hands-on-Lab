
INSTALL_DIR=/mnt/sda2 && \
rm -r -f $INSTALL_DIR/PyLab && \
git clone --depth=1 git://github.com/gloveboxes/PyCon-Hands-on-Lab.git $INSTALL_DIR/PyLab && \
chmod +x $INSTALL_DIR/PyLab/Lab-setup/setup/*.sh && \
cd $INSTALL_DIR/PyLab/Lab-setup/setup