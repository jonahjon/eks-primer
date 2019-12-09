#! /bin/bash

set -eo pipefail

source ./common.sh  

#./06_sample_2tier_app.sh -d true
while getopts ":d:" opt; do
  case $opt in
    d)
      echo "-d delete was triggered, Parameter: $OPTARG" >&2
      kubectl delete crd prometheuses.monitoring.coreos.com
      kubectl delete crd prometheusrules.monitoring.coreos.com
      kubectl delete crd servicemonitors.monitoring.coreos.com
      kubectl delete crd podmonitors.monitoring.coreos.com
      kubectl delete crd alertmanagers.monitoring.coreos.com
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl get deployment --namespace kube-system

kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &

aws eks get-token --cluster-name $name | jq -r '.status.token'

open http://localhost:8080/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

