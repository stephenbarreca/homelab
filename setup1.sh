sudo apt install nfs-common
sudo snap install microk8s --channel=1.21/stable --classic
sudo usermod -a -G microk8s "$USER"
sudo chown -f -R "$USER" ~/.kube