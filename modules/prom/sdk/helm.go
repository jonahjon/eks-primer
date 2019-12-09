package main

import (
	"log"

	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/chart/loader"
)

var (
	values    = make(map[string]interface{})
	namespace = "testNamespace"
	strict    = false
)

func main() {
	tests := []struct {
		name      string
		chartPath string
	}{
		{
			name:      "prometheus-operator",
			chartPath: "../prometheus-operator/",
		},
		{
			name:      "grafana",
			chartPath: "../prometheus-operator/charts/grafana/",
		},
		{
			name:      "kube-state-metrics",
			chartPath: "../prometheus-operator/charts/kube-state-metrics/",
		},
		{
			name:      "prometheus-node-exporter",
			chartPath: "../prometheus-operator/charts/prometheus-node-exporter/",
		},
	}
	testLint := action.NewLint()
	for _, tt := range tests {
		loader, err := loader.Loader(tt.chartPath)
		if err != nil {
			log.Printf("Failed to load Chart: %s", tt.name)
		}
		c, err := loader.Load()
		log.Printf("Success Loadeding Chart: %s", c.Name())
		if c.Name() != tt.name {
			log.Printf("Expected %s, got %s", tt.name, c.Name())
		}
		testChart := []string{tt.chartPath}
		if result := testLint.Run(testChart, values); len(result.Errors) > 0 {
			log.Printf("Lint failed results %v", result)
		} else {
			log.Printf("Linting passed for %s", tt.name)
		}
	}
}
