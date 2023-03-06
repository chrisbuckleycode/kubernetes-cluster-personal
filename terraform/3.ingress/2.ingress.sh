#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "no DO_API_TOKEN supplied as first arg"
    exit 1
fi


export KUBE_CONFIG_PATH=~/.kube/config
NGINX_CHART_VERSION="4.1.3"
CERT_MANAGER_HELM_CHART_VERSION="1.8.0"

kubectl create ns backend

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update ingress-nginx
helm install ingress-nginx \
  ingress-nginx/ingress-nginx \
  --version "$NGINX_CHART_VERSION" \
  --namespace ingress-nginx \
  --create-namespace \
  -f "manifests/nginx-values-v${NGINX_CHART_VERSION}.yaml" \
  --wait
kubectl -n ingress-nginx rollout status deploy/ingress-nginx

helm repo add jetstack https://charts.jetstack.io
helm repo update jetstack
helm install \
  cert-manager jetstack/cert-manager \
  --version "$CERT_MANAGER_HELM_CHART_VERSION" \
  --namespace cert-manager \
  --create-namespace \
  -f manifests/cert-manager-values-v${CERT_MANAGER_HELM_CHART_VERSION}.yaml \
  --wait
kubectl -n cert-manager rollout status deploy/cert-manager

kubectl create secret generic "digitalocean-dns" --namespace backend --from-literal=access-token="$1"
kubectl apply -f manifests/cert-manager-wcard-issuer.yaml
kubectl apply -f manifests/cert-manager-wcard-certificate.yaml
kubectl apply -f manifests/wildcard-host.yaml

kubectl apply -f manifests/echo_deployment.yaml
kubectl apply -f manifests/quote_deployment.yaml
kubectl apply -f manifests/echo_service.yaml
kubectl apply -f manifests/quote_service.yaml

kubectl get all -n ingress-nginx
echo "Go configure DNS"
