allow_k8s_contexts('arn:aws:eks:us-west-2:164382793440:cluster/github')
print('Hello Tiltfile')
yaml = helm(
  'modules/prom/prometheus-operator',
  name='prom',
  namespace='monitoring',
  # The values file to substitute into the chart.
  #values=['./path/to/chart/dir/values-dev.yaml'],
  # Values to set from the command-line
  #set=['service.port=1234', 'ingress.enabled=true']
  )
text = local('helm lint ./modules/prom/prometheus-operator') # runs command foo.py

k8s_yaml(yaml)

