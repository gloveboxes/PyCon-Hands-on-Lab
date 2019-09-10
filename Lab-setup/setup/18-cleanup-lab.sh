for i in {01..25}
do
    sudo deluser dev$i
done

echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010_pi-nopasswd && \
sudo rm -r /home/dev*

# clean up docker images
sudo systemctl start docker
docker stop pi-sense-hat
docker rm $(docker ps -a -q)
docker rmi $(docker images -q) -f
sudo systemctl stop docker