#! /bin/bash

set -eo pipefail

source ./common.sh  

cd modules/fargate

aws iam create-role --role-name AmazonEKSFargatePodExecutionRole --assume-role-policy-document file://relationship.json || true

aws iam attach-role-policy --role-name AmazonEKSFargatePodExecutionRole --policy-arn arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy || true

eksctl create fargateprofile --cluster $name --name fargate_$name --namespace default --labels app=ecsdemo-nodejs

kubectl rollout restart -n kube-system deployment ecsdemo-nodejs
