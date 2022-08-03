#!/bin/bash
# Source: https://github.com/minio/operator

wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create lab-cluster --volume /mnt/data:/tmp/k3dvol --api-port 6443 --servers 1 --agents 3 -p 80:80@loadbalancer -p 443:443@loadbalancer -p "30000-30010:30000-30010@server:0"

sleep 30

mkdir ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --set "controller.extraArgs.enable-ssl-passthrough=true"


kubectl create namespace minio-tenant-1
kubectl apply -f minio-pv.yml

kubectl krew install minio
wget https://github.com/minio/operator/releases/latest/download/kubectl-minio_linux_amd64.zip -P /tmp/
sudo unzip /tmp/kubectl-minio_linux_amd64.zip -d /usr/local/bin
sudo chmod +x /usr/local/bin/kubectl-minio

kubectl minio init

kubectl port-forward --address 0.0.0.0 svc/tenant1-console 9443:9443 -n minio-tenant-1