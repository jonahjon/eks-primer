#! /bin/bash

set -eo pipefail

source ./common.sh  
      
#upgrade to helm 3
#brew upgrade helm

export helmdir=$(pwd)
helm version
helm repo add stable https://kubernetes-charts.storage.googleapis.com
#kubectl apply -f modules/helm/helm_rbac.yaml