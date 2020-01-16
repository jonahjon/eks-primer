#! /bin/bash

set -eo pipefail

source ./common.sh  

cd modules/fluentd

STACK_NAME_A=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupa" -o json | jq -r '.[].StackName')
ROLE_NAME_A=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_A | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam put-role-policy --role-name $ROLE_NAME_A --policy-name Logs-Policy-For-Worker --policy-document file://k8s-logs-policy.json || true


STACK_NAME_B=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupb" -o json | jq -r '.[].StackName')
ROLE_NAME_B=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_B | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam put-role-policy --role-name $ROLE_NAME_B --policy-name Logs-Policy-For-Worker --policy-document file://k8s-logs-policy.json || true



eks-fluent-bit-daemonset-rbac.yaml

eks-fluent-bit-daemonset.yaml
