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
#----------------

#----------------
# PIHOLE
echo "[pihole] creating namespace pihole"
microk8s.kubectl create namespace pihole
echo "[pihole] configuring pihole storage"
microk8s.kubectl apply -f $PIHOLE/pihole.nfs.storage.yml
echo "[pihole] Installing pihole helmchart"
microk8s.helm3 install -n pihole --values $PIHOLE/values.yaml pihole $PIHOLE/pihole-1.7.8.tgz
#----------------

#----------------
# PLEX
echo "[plex] creating namespace plex"
microk8s.kubectl create namespace plex

echo "[plex] configuring plex local storage"
microk8s.kubectl apply -f $PLEX/plex.local.storage.yml
echo "[plex] configuring plex nfs storage"
microk8s.kubectl apply -f $PLEX/plex.nfs.storage.yml
echo "[plex] installing plex helmchart"
microk8s.helm3 install -n plex --values $PLEX/values.yaml plex $PLEX/kube-plex-0.2.7.tgz

echo "[plex] configuring transmission nfs storage"
microk8s.kubectl apply -f $TRANSMISSION/transmission.nfs.storage.yml
echo "[plex] installing transmission helmchart"
microk8s.helm3 install -n plex --values $TRANSMISSION/values.yaml transmission $QBITTORRENT/transmission-openvpn-0.1.0.tgz

echo "[plex] configuring ombi nfs storage"
microk8s.kubectl apply -f $OMBI/ombi.nfs.storage.yml
echo "[plex] installing ombi helmchart"
microk8s.helm3 install -n plex --values $OMBI/values.yaml ombi $OMBI/ombi-2.2.1.tgz

echo "[plex] configuring jackett nfs storage"
microk8s.kubectl apply -f $JACKETT/jackett.nfs.storage.yml
echo "[plex] installing jackett helmchart"
microk8s.helm3 install -n plex --values $JACKETT/values.yaml jackett $JACKETT/jackett-0.1.0.tgz

echo "[plex] configuring radarr nfs storage"
microk8s.kubectl apply -f $RADARR/radarr.nfs.storage.yml
echo "[plex] installing radarr helmchart"
microk8s.helm3 install -n plex --values $RADARR/values.yaml radarr $RADARR/radarr-0.1.0.tgz
echo "[plex] creating radarr loadbalancer"
microk8s.kubectl apply -f $RADARR/radarr.svc.yml

echo "[plex] configuring sonarr nfs storage"
microk8s.kubectl apply -f $SONARR/sonarr.nfs.storage.yml
echo "[plex] installing sonarr helmchart"
microk8s.helm3 install -n plex --values $SONARR/values.yaml sonarr $SONARR/sonarr/
echo "[plex] creating sonarr loadbalancer"
microk8s.kubectl apply -f $SONARR/radarr.svc.yml

echo "[plex] configuring tautulli nfs storage"
microk8s.kubectl apply -f $TAUTULLI/tautulli.nfs.storage.yml
echo "[plex] installing tautulli helmchart"
microk8s.helm3 install -n plex --values $TAUTULLI/values.yaml tautulli $TAUTULLI/tautulli-2.2.0.tgz
#----------------

#----------------
# GITEA
echo "[gitea] creating namespace gitea"
microk8s.kubectl create namespace gitea
echo "[gitea] configuring gitea nfs storage"
microk8s.kubectl apply -f $GITEA/gitea.nfs.storage.yml
echo "[gitea] configuring postgres nfs storage"
microk8s.kubectl apply -f $GITEA/postgres-gitea.nfs.storage.yml
echo "[gitea] installing gitea helmchart"
microk8s.helm3 install -n gitea --values $GITEA/values.yaml gitea $GITEA/gitea-1.11.5.tgz
#----------------

#----------------
# HEIMDALL
echo "[heimdall] creating namespace heimdall"
microk8s.kubectl create namespace heimdall
echo "[heimdall] configuring heimdall nfs storage"
microk8s.kubectl apply -f $HEIMDALL/heimdall.nfs.storage.yml
echo "[heimdall] installing heimdall helmchart"
microk8s.helm3 install -n heimdall --values $HEIMDALL/values.yaml heimdall $HEIMDALL/heimdall-1.0.1.tgz
#----------------

#----------------
# MONITORING
echo "[monitoring] creating namespace monitoring"
microk8s.kubectl create namespace monitoring
echo "[monitoring] configuring grafana nfs storage"
microk8s.kubectl apply -f $MONITORING/grafana.nfs.storage.yml
echo "[monitoring] installing prometheus-operator helmchart"
microk8s.helm3 install -n monitoring --values $MONITORING/prometheus-operator/values.yaml prometheus-operator $MONITORING/prometheus-operator/prometheus-operator-8.15.6.tgz
#----------------
echo "Kubernetes setup complete"

