#! /bin/bash

set -eo pipefail

source ./common.sh  

export nodegroupa="$name-ng-a"
export nodegroupb="$name-ng-b"

export AWS_CLUSTER_NAME=$name
export KF_NAME=${AWS_CLUSTER_NAME}
export BASE_DIR=$(pwd)
export KF_DIR=${BASE_DIR}/modules/kubeflow

eksctl scale nodegroup --cluster $name --name $nodegroupa --nodes 6

curl --silent --location "https://github.com/kubeflow/kubeflow/releases/download/v0.7.1/kfctl_v0.7.1-2-g55f9b2a_darwin.tar.gz" | tar xz -C .
sudo mv -v kfctl /usr/local/bin

export CONFIG_URI=https://raw.githubusercontent.com/kubeflow/manifests/v0.7-branch/kfdef/kfctl_aws.0.7.0.yaml

curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin

mkdir -p ${KF_DIR}
cd ${KF_DIR}
kfctl build -V -f ${CONFIG_URI}

export HASH=$(LC_CTYPE=C < /dev/urandom tr -dc a-z0-9 | head -c8)
export S3_BUCKET=$HASH-eks-ml-data
aws s3 mb s3://$S3_BUCKET --region $AWS_REGION

AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) && export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) && export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID


curl -LO https://eksworkshop.com/advanced/420_kubeflow/kubeflow.files/mnist-inference.yaml
j2 $KF_DIR/mnist-training.yaml.j2 > $KF_DIR/mnist-training.yaml
kubectl apply -f $KF_DIR/mnist-training.yaml.j2
kubectl logs mnist-training -f

curl -LO https://eksworkshop.com/advanced/420_kubeflow/kubeflow.files/mnist-inference.yaml

j2 $KF_DIR/mnist-training.yaml.j2 > $KF_DIR/mnist-training.yaml
