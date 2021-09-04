sudo apt install nfs-common
sudo snap install microk8s --channel=1.21/stable --classic
sudo usermod -a -G microk8s "$USER"
sudo chown -f -R "$USER" ~/.kube
sudo snap alias microk8s.kubectl kubectl
echo "source <(kubectl completion bash)" >> /home/stephen/.bashrc
sudo snap alias microk8s.helm3 helm
echo "source <(helm completion bash)" >> /home/stephen/.bashrc