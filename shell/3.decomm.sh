#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No cluster name supplied as first arg"
    exit 1
fi

LBID=$(doctl compute load-balancer list --format ID | sed -n 2p)
DROPLETID=$(doctl compute droplet list --format ID | sed -n 2p)

doctl k8s cluster delete $1
doctl k8s cluster list

doctl compute load-balancer delete $LBID
doctl compute droplet delete $DROPLETID