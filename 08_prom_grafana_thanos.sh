#! /bin/bash

set -eo pipefail

source ./common.sh  

#./08_prom_grafana_thanos.sh -d true
while getopts d: option; do
  case "${option}" in 
    d)
      echo "-d delete was triggered, Parameter: ${OPTARG}";
      helm delete prom;
      kubectl delete crd prometheuses.monitoring.coreos.com;
      kubectl delete crd prometheusrules.monitoring.coreos.com;
      kubectl delete crd servicemonitors.monitoring.coreos.com;
      kubectl delete crd podmonitors.monitoring.coreos.com;
      kubectl delete crd alertmanagers.monitoring.coreos.com;
      helm delete thanos;
      exit 1
      ;;
    \?)
      echo "Invalid option: ${OPTARG}";
      exit 1
      ;;
  esac
done

#Get Access Keys still
AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key) && export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) && export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID

j2 modules/prom/prometheus-operator/object-store.yaml.j2 > modules/prom/prometheus-operator/object-store.yaml --undefined

# Create Monitoring Namespace
kubectl apply -f modules/prom/namespace.yml

helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com

helm repo update

helm upgrade --install thanos --namespace monitoring banzaicloud-stable/thanos --set-file objstoreFile=modules/prom/prometheus-operator/object-store.yaml


# Create Secret for Prom
kubectl -n monitoring create secret generic thanos-objstore-config --from-file=modules/prom/prometheus-operator/object-store.yaml || true


# Create Prom
helm upgrade --install prom --namespace monitoring ./modules/prom/prometheus-operator

kubectl --namespace monitoring get pods -l "release=prom"


# Different ways to load tests

#while sleep 1; do curl http://elb.com/; done

#echo "GET http://a821119f3115911eaadd50e0cca30225-1605152951.us-west-2.elb.amazonaws.com/" | vegeta attack -rate=50/s -duration=1m | vegeta encode > results.json && vegeta report results.json && rm -rf results.json

# echo 'GET http://a821119f3115911eaadd50e0cca30225-1605152951.us-west-2.elb.amazonaws.com' | \
#     vegeta attack -rate 50/s -duration 30s | vegeta encode \
#     jaggr @count=rps \
#           hist\[100,200,300,400,500\]:code | \
#     jplot rps+code.hist.100+code.hist.200+code.hist.300+code.hist.400+code.hist.500 \