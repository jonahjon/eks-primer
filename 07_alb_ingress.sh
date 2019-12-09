#! /bin/bash

set -eo pipefail

source ./common.sh 

cd modules/alb-ingress

#./08_alb_ingress.sh -d true
while getopts d: option; do
  case "${option}" in 
    d)
      echo "-d delete was triggered, Parameter: ${OPTARG}";
      kubectl delete -f rbac-role.yaml
      kubectl delete -f alb-ingress-controller.yaml
      exit 1
      ;;
    \?)
      echo "Invalid option: ${OPTARG}";
      exit 1
      ;;
  esac
done

export nodegroupa="$name-ng-a"
export nodegroupb="$name-ng-b"

STACK_NAME_A=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupa" -o json | jq -r '.[].StackName')
STACK_NAME_B=$(eksctl get nodegroup --cluster "$name" --name "$nodegroupb" -o json | jq -r '.[].StackName')
ROLE_NAME_A=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_A | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)
ROLE_NAME_B=$(aws cloudformation describe-stacks --stack-name $STACK_NAME_B | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="InstanceRoleARN") | .OutputValue' | cut -f2 -d/)

aws iam create-policy \
--policy-name ALBIngressControllerIAMPolicy \
--policy-document file://iam-policy.json || true

aws iam attach-role-policy \
--policy-arn arn:aws:iam::$account_id:policy/ALBIngressControllerIAMPolicy \
--role-name $ROLE_NAME_A || true

aws iam attach-role-policy \
--policy-arn arn:aws:iam::$account_id:policy/ALBIngressControllerIAMPolicy \
--role-name $ROLE_NAME_B || true

j2 alb-ingress-controller.yaml.j2 > alb-ingress-controller.yaml --undefined

kubectl apply -f rbac-role.yaml
kubectl apply -f alb-ingress-controller.yaml

kubectl logs -n kube-system   deployment.apps/alb-ingress-controller

cd $pwd