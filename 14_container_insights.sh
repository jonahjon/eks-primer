#! /bin/bash

set -eo pipefail

source ./common.sh  

cd modules/container-insights

pwd=$(pwd)
export nodegroupa="$name-ng-a"
export nodegroupb="$name-ng-b"

STACK_NAME_A=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupa" -o json | jq -r '.[].StackName')
ROLE_NAME_A=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_A | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam attach-role-policy --role-name $ROLE_NAME_A --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy || true


STACK_NAME_B=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupb" -o json | jq -r '.[].StackName')
ROLE_NAME_B=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_B | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam attach-role-policy --role-name $ROLE_NAME_B --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy || true

j2 cwagent-fluentd-quickstart.yaml.j2 > cwagent-fluentd-quickstart.yaml --undefined

kubectl apply -f cwagent-fluentd-quickstart.yaml

