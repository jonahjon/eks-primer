module github.com/jonahjon/eks-primer/prometheus-operator

go 1.12

require (
	github.com/docker/docker v1.13.1 // indirect
	golang.org/x/net v0.0.0-20191206103017-1ddd1de85cb0 // indirect
	helm.sh/helm/v3 v3.0.1 // indirect
)

replace github.com/docker/docker => github.com/moby/moby v0.7.3-0.20190826074503-38ab9da00309
