#! /bin/bash

set -eo pipefail

source ./common.sh  

#./05_sample_2tier_app.sh -d true
while getopts ":d:" opt; do
  case $opt in
    d)
      echo "-d delete was triggered, Parameter: $OPTARG" >&2
      pwd=$(pwd)
      kubectl delete -f modules/sample-apps/ecsdemo-nodejs/kubernetes/
      kubectl delete -f modules/sample-apps/ecsdemo-crystal/kubernetes/
      kubectl delete -f modules/sample-apps/ecsdemo-frontend/kubernetes/
      kubectl get deployments
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

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



# You need the requests portion in your Deployment container spec to have HPA scale