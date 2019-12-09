#! /bin/bash

export $(xargs <.env)
export name=$NAME
export region=$REGION
export iamrole=$IAM_ROLE
export KUBECTL_FILE=$KUBECTL_FILE
export thanos_bucket=$THANOS_BUCKET
export account_id=$ACCOUNT_ID
export pwd=$(pwd)