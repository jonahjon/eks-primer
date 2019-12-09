#! /bin/bash

set -eo pipefail

source ./common.sh  

pwd=$(pwd)

# Horizontal Pod Autoscaler
kubectl apply -f  modules/scaling/ --validate=false
kubectl config set-context --current --namespace=kube-system
helm install stable/metrics-server --namespace metrics --generate-name
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
