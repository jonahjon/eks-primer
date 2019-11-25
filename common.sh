#! /bin/bash

export $(xargs <.env)
export name=$NAME
export region=$REGION
export iamrole=$IAM_ROLE
export KUBECTL_FILE=$KUBECTL_FILE

