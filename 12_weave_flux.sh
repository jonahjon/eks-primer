#! /bin/bash

set -eo pipefail

source ./common.sh  

cd modules/weave

aws iam create-role --role-name eksworkshop-CodePipelineServiceRole --assume-role-policy-document file://cpAssumeRolePolicyDocument.json || true

aws iam put-role-policy --role-name eksworkshop-CodePipelineServiceRole --policy-name codepipeline-access --policy-document file://cpPolicyDocument.json || true

aws iam create-role --role-name eksworkshop-CodeBuildServiceRole --assume-role-policy-document file://cbAssumeRolePolicyDocument.json || true

aws iam put-role-policy --role-name eksworkshop-CodeBuildServiceRole --policy-name codebuild-access --policy-document file://cbPolicyDocument.json || true

kubectl apply -f flux-helm-release-crd.yaml

helm repo add fluxcd https://charts.fluxcd.io

helm upgrade -i flux \
--set helmOperator.create=true \
--set helmOperator.createCRD=false \
--set git.url=git@github.com:jonahjon/eks-primer \
--namespace default \
fluxcd/flux

deploykey=$(kubectl -n default logs deployment/flux | grep identity.pub | cut -d '"' -f2)

brew install fluxctl
fluxctl version
fluxctl identity --k8s-fwd-ns default

j2 $pwd/workloads/eks-example-dep.yaml.j2 > $pwd/workloads/eks-example-dep.yaml --undefined

cd $pwd