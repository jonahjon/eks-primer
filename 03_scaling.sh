#! /bin/bash

set -eo pipefail

source ./common.sh  

kubectl apply -f  modules/scaling/
kubectl config set-context --current --namespace=kube-system
helm install stable/metrics-server --name metrics-server --namespace metrics
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml