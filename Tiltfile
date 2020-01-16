allow_k8s_contexts('arn:aws:eks:us-west-2:164382793440:cluster/github')
print('Loading up local Development')

prom_helm = helm(
  'modules/prom/prometheus-operator',
  name='prom',
  namespace='monitoring',
  # The values file to substitute into the chart.
  #values=['./path/to/chart/dir/values-dev.yaml'],
  # Values to set from the command-line
  #set=['service.port=1234', 'ingress.enabled=true']
  )
k8s_yaml(prom_helm)

3_tier_helm = helm(
  'modules/prom/prometheus-operator',
  name='prom',
  namespace='monitoring',
  # The values file to substitute into the chart.
  #values=['./path/to/chart/dir/values-dev.yaml'],
  # Values to set from the command-line
  #set=['service.port=1234', 'ingress.enabled=true']
  )
k8s_yaml(3_tier_helm)





local('')


