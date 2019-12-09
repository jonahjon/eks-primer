#!/usr/bin/env bash

########################
# include the magic
########################
source ./demo-magic.sh

clear


TYPE_SPEED=10

DEMO_PROMPT="${GREEN}➜ ${GREEN}\W "

pe "cd modules/prom"

cmd

pe "helm template prom ./prometheus-operator --namespace monitoring"

pe "helm template prom ./prometheus-operator --namespace monitoring"

pe "helm template prom ./prometheus-operator --namespace monitoring"

pe "cd sdk"

cmd

pe "go run helm.go"

pe "go run helm.go"

