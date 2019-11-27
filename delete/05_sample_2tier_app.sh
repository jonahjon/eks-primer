#! /bin/bash

set -eo pipefail

source ./common.sh  

# Cluster Autoscaler
pwd=$(pwd)

# Check Node API
kubectl delete -f modules/sample-apps/ecsdemo-nodejs/kubernetes/

# Check Crystal API
kubectl delete -f modules/sample-apps/ecsdemo-crystal/kubernetes/

# Check Frontend API
kubectl delete -f modules/sample-apps/ecsdemo-frontend/kubernetes/

kubectl get deployments