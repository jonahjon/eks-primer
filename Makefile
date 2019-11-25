SHELL := /bin/bash
check: pip-exists eksctl-exists kubectl-exists
eksctl-exists: ; @eksctl version > /dev/null #brew install weaveworks/tap/eksctl brew upgrade eksctl && brew link --overwrite eksctl
pip-exists: ; @which pip > /dev/null
kubectl-exists: ; @kubectl version > /dev/null

mytarget: check
.PHONY: check

cluster: check
	chmod +x 01_kubectl.sh && ./01_kubectl.sh
	chmod +x 02_helm.sh && ./02_helm.sh



	