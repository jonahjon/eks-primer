#! /bin/bash

set -eo pipefail

source ./common.sh  

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

k get deployment --namespace kube-system

kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &

aws eks get-token --cluster-name $name | jq -r '.status.token'

open http://localhost:8080/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

