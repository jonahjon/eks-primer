#! /bin/bash

set -eo pipefail

source ./common.sh

j2 kubectl/$KUBECTL_FILE.j2 > kubectl/$KUBECTL_FILE --undefined
eksctl create cluster -f kubectl/$KUBECTL_FILE
eksctl utils describe-stacks --region=$region --cluster=$name
aws eks update-kubeconfig --name $name
kubectl get svc
