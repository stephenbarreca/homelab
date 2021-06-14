#!/bin/bash

CORE="${HOME}/k8s"
PIHOLE="${CORE}/pihole"
PLEX_CORE="${CORE}/plex"
PLEX="${PLEX_CORE}/kube-plex"
RADARR="${PLEX_CORE}/radarr"
SONARR="${PLEX_CORE}/sonarr"
JACKETT="${PLEX_CORE}/jackett"
OMBI="${PLEX_CORE}/ombi"
QBITTORRENT="${PLEX_CORE}/qbittorrent"
TRANSMISSION="${PLEX_CORE}/transmission-openvpn"
TAUTULLI="${PLEX_CORE}/tautulli"
GITEA="${CORE}/gitea"
HEIMDALL="${CORE}/heimdall"
MONITORING="${CORE}/monitoring"
GPU="${CORE}/gpu-operator"

export SNAP_DATA=/var/snap/microk8s/current
export SNAP_COMMON=/var/snap/microk8s/common
export CONFIG="$SNAP_DATA/args/containerd-template.toml"
export SOCKET="$SNAP_COMMON/run/containerd.sock"

alias kubectl=microk8s.kubectl
alias helm=microk8s.helm3
#----------------
echo "disabling microk8s ha-cluster"
microk8s disable ha-cluster --force
echo "enabling microk8s features"
#microk8s enable dns helm3 metallb metrics-server
microk8s enable dns helm3
#----------------
#----------------
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add nvidia https://nvidia.github.io/gpu-operator
helm repo update
#----------------
#----------------
# PIHOLE
svc=pihole
echo "[$svc] creating namespace '$svc'"
kubectl create namespace $svc
echo "[$svc] configuring storage"
kubectl apply -f "$PIHOLE"/pihole.nfs.storage.yml
echo "[$svc] Installing helmchart"
helm install -n "$svc" --values "$PIHOLE"/values.yaml pihole "$PIHOLE"/pihole-1.7.8.tgz
#----------------
#----------------
# MONITORING
svc=monitoring
echo "[monitoring] creating namespace monitoring"
kubectl create namespace $svc
echo "[monitoring] configuring grafana nfs storage"
kubectl apply -f "$MONITORING"/grafana.nfs.storage.yml
echo "[monitoring] configuring prometheus nfs storage"
kubectl apply -f "$MONITORING"/prometheus.nfs.storage.yml
echo "[monitoring] installing prometheus-operator helmchart"
helm install -n "$svc" --values "$MONITORING"/prometheus-community/kube-prometheus-stack/values.yaml prometheus-operator prometheus-community/kube-prometheus-stack
#echo "[monitoring] installing dcgm-exporter helmchart"
#helm install -n "$svc" --values "$MONITORING"/dcgm-exporter/values.yaml dcgm-exporter "$MONITORING"/dcgm-exporter/dcgm-exporter-2.3.1.tgz
#----------------
#----------------
# GPU
svc=gpu-operator
echo "[$svc] Updating Nvidia helm repo"
echo "[$svc] Installing helmchart"
helm install --values "$GPU"/values.yaml $svc nvidia/gpu-operator --version=v1.7.0

#----------------

#----------------
# PLEX
svc=plex
echo "[$svc] creating namespace '$svc'"
kubectl create namespace $svc

echo "[$svc] configuring plex local storage"
kubectl apply -f "$PLEX"/plex.local.storage.yml
echo "[$svc] configuring plex nfs storage"
kubectl apply -f "$PLEX"/plex.nfs.storage.yml
echo "[$svc] installing plex helmchart"
helm install -n "$svc" --values "$PLEX"/values.yaml plex "$PLEX"/kube-plex-0.2.7.tgz

echo "[$svc] configuring transmission nfs storage"
kubectl apply -f "$TRANSMISSION"/transmission.nfs.storage.yml
echo "[$svc] installing transmission helmchart"
helm install -n "$svc" --values "$TRANSMISSION"/values.yaml transmaission "$TRANSMISSION"/transmission-openvpn-0.1.0.tgz
echo "[$svc] creating transmission loadbalancer"
kubectl apply -f "$TRANSMISSION"/transmission.svc.yaml

echo "[$svc] configuring jackett nfs storage"
kubectl apply -f "$JACKETT"/jackett.nfs.storage.yml
echo "[$svc] installing jackett helmchart"
helm install -n "$svc" --values "$JACKETT"/values.yaml jackett "$JACKETT"/jackett/

echo "[$svc] configuring radarr nfs storage"
kubectl apply -f "$RADARR"/radarr.nfs.storage.yml
echo "[$svc] installing radarr helmchart"
helm install -n "$svc" --values "$RADARR"/values.yaml radarr "$RADARR"/radarr-0.1.0.tgz
echo "[$svc] creating radarr loadbalancer"
kubectl apply -f "$RADARR"/radarr.svc.yml

echo "[$svc] configuring sonarr nfs storage"
kubectl apply -f "$SONARR"/sonarr.nfs.storage.yml
echo "[$svc] installing sonarr helmchart"
helm install -n "$svc" --values "$SONARR"/values.yaml sonarr "$SONARR"/sonarr/
echo "[$svc] creating sonarr loadbalancer"
kubectl apply -f "$SONARR"/sonarr.svc.yml

echo "[$svc] configuring tautulli nfs storage"
kubectl apply -f "$TAUTULLI"/tautulli.nfs.storage.yml
echo "[$svc] installing tautulli helmchart"
helm install -n "$svc" --values "$TAUTULLI"/values.yaml tautulli "$TAUTULLI"/tautulli-2.2.0.tgz

echo "[$svc] configuring ombi nfs storage"
kubectl apply -f "$OMBI"/ombi.nfs.storage.yml
echo "[$svc] installing ombi helmchart"
helm install -n "$svc" --values "$OMBI"/values.yaml ombi "$OMBI"/ombi-2.2.1.tgz
#----------------
#----------------
# GITEA
svc=gitea
helm repo add gitea-charts https://dl.gitea.io/charts/
echo "[gitea] creating namespace gitea"
kubectl create namespace gitea
kubectl apply -f secret.yaml
echo "[gitea] configuring gitea nfs storage"
kubectl apply -f "$GITEA"/gitea.nfs.storage.yml
echo "[gitea] configuring postgres nfs storage"
kubectl apply -f "$GITEA"/postgres-gitea.nfs.storage.yml
echo "[gitea] installing gitea helmchart"
helm install -n "$svc" --values "$GITEA"/gitea-official/values.yaml gitea gitea-charts/gitea
#----------------
#----------------
# HEIMDALL
echo "[heimdall] creating namespace heimdall"
kubectl create namespace heimdall
echo "[heimdall] configuring heimdall nfs storage"
kubectl apply -f "$HEIMDALL"/heimdall.nfs.storage.yml
echo "[heimdall] installing heimdall helmchart"
helm install -n "$svc" --values "$HEIMDALL"/values.yaml heimdall "$HEIMDALL"/heimdall-1.0.1.tgz
#----------------

echo "Kubernetes setup complete"

echo "alias kubectl='microk8s kubectl'" >> /home/"$USER"/.bashrc
echo "alias helm='microk8s helm3'" >> /home/"$USER"/.bashrc
