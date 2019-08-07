for i in {01..40}
do
    sudo deluser dev$i
done

sudo rm -r /home/dev*

echo "pi ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/010_pi-nopasswd