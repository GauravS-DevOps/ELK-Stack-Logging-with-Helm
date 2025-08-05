#!/bin/bash

# Create Namespace
kubectl create ns elk

# Add Helm Repo
helm repo add elastic https://helm.elastic.co
helm repo update

# Install Elasticsearch
helm install elasticsearch elastic/elasticsearch -n elk

# Install Kibana
helm install kibana elastic/kibana -n elk --set service.type=ClusterIP

# Install Logstash
helm install logstash elastic/logstash -n elk

# Install Metricbeat
helm install metricbeat elastic/metricbeat -n elk

# Install Filebeat with credentials
helm install filebeat elastic/filebeat -n elk \
  --set elasticsearch.hosts="{http://elasticsearch-master:9200}" \
  --set elasticsearch.username="elastic" \
  --set elasticsearch.password="password"
