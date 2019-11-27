#! /bin/bash

set -eo pipefail

source ./common.sh  

# Cluster Autoscaler
pwd=$(pwd)

# Check Node API
kubectl apply -f modules/sample-apps/ecsdemo-nodejs/kubernetes/
kubectl get deployment ecsdemo-nodejs

# Check Crystal API
kubectl apply -f modules/sample-apps/ecsdemo-crystal/kubernetes/
kubectl get deployment ecsdemo-crystal


# Check Frontend API
kubectl apply -f modules/sample-apps/ecsdemo-frontend/kubernetes/
kubectl get deployment ecsdemo-frontend

# This takes about a min, so re-run script if first go through
ELB=$(kubectl get service ecsdemo-frontend -o json | jq -r '.status.loadBalancer.ingress[].hostname')

open http://$ELB
