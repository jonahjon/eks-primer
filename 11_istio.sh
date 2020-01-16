#! /bin/bash

set -eo pipefail

source ./common.sh  

cd modules/istio/kubernetes

brew install istioctl

kubectl apply -f helm/helm-service-account.yaml

kubectl apply -f namespace.yaml

helm upgrade --install istio-init --namespace istio-system ./helm/istio-init 

helm upgrade --install istio --namespace istio-system  ./helm/istio --set global.configValidation=false --set sidecarInjectorWebhook.enabled=false --set grafana.enabled=true --set servicegraph.enabled=true

kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)

kubectl apply -f istio-telemetry.yaml

kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 8080:3000 &

http://localhost:8080/dashboard/db/istio-mesh-dashboard

http://a702750f029a511eaa8110241261d66f-34782750.us-west-2.elb.amazonaws.com/productpage