#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No cluster name supplied as first arg"
    exit 1
fi

doctl k8s cluster create $1 \
  --auto-upgrade=false \
  --surge-upgrade=false \
  --ha=false \
  --node-pool "name=basicnp;size=s-2vcpu-4gb;count=1;tag=$1;label=type=basic;auto-scale=false" \
  --region ams3

export KUBE_CONFIG_PATH=~/.kube/config
doctl k8s cluster list
kubectl get no
