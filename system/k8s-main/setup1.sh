#!/bin/bash
sudo apt install nfs-common
sudo snap install microk8s --channel=1.21/stable --classic
sudo usermod -a -G microk8s "$USER"
sudo chown -f -R "$USER" ~/.kube
sudo snap alias microk8s.kubectl kubectl
echo "source <(kubectl completion bash)" >> /home/stephen/.bashrc
sudo snap alias microk8s.helm3 helm
echo "source <(helm completion bash)" >> /home/stephen/.bashrc

echo "enabling microk8s features"
sudo microk8s enable metallb
sudo microk8s enable hostpath-storage
sudo microk8s enable gpu

CORE_DIR="/data"
sudo mkdir $CORE_DIR
sudo chown "$USER:$USER" $CORE_DIR
mkdir -p $CORE_DIR/local
mkdir -p $CORE_DIR/network/media/books
mkdir -p $CORE_DIR/network/media/movies
mkdir -p $CORE_DIR/network/media/tv
mkdir -p $CORE_DIR/network/minecraft

echo "install taskfile"
sudo snap install task --classic


