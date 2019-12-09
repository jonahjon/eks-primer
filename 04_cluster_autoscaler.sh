#! /bin/bash

set -eo pipefail

source ./common.sh  

# Cluster Autoscaler
pwd=$(pwd)
export nodegroupa="$name-ng-a"
export nodegroupb="$name-ng-b"


STACK_NAME_A=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupa" -o json | jq -r '.[].StackName')
#INSTANCE_PROFILE_ARN_A=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_A | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceProfileARN") | .OutputValue')
ROLE_NAME_A=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_A | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam put-role-policy --role-name $ROLE_NAME_A --policy-name ASG-Policy-For-Worker --policy-document file://$pwd/modules/scaling/asg-policy.json
export ASG_NAME_A=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].[AutoScalingGroupName]' --output text | grep "eksctl-$name-nodegroup-$name-ng-a")


STACK_NAME_B=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupb" -o json | jq -r '.[].StackName')
#INSTANCE_PROFILE_ARN_B=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_B | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceProfileARN") | .OutputValue')
ROLE_NAME_B=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_B | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
aws iam put-role-policy --role-name $ROLE_NAME_B --policy-name ASG-Policy-For-Worker --policy-document file://$pwd/modules/scaling/asg-policy.json
export ASG_NAME_B=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[].[AutoScalingGroupName]' --output text | grep "eksctl-$name-nodegroup-$name-ng-b")

j2 modules/scaling/cluster-autoscaler.yml.j2 > modules/scaling/cluster-autoscaler.yml --undefined
kubectl apply -f modules/scaling/cluster-autoscaler.yml

# kubectl logs -f deployment/cluster-autoscaler -n kube-system