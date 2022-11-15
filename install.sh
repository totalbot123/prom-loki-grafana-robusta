#!/bin/bash

# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Grafana + Loki
helm repo add grafana https://grafana.github.io/helm-charts

# Robusta


helm repo update

# Install Prometheus
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --create-namespace \
  --values minimal-prometheus.yaml

# Install Loki
helm upgrade --install loki grafana/loki-stack \
  --namespace monitoring \
  --create-namespace \
  --wait

# Install Grafana
helm upgrade --install grafana grafana/grafana \
  --namespace monitoring \
  --create-namespace \
  --values minimal-grafana.yaml \
  --wait

# Print Grafana PW
echo -n "Grafana password: "
kubectl secrets get -n monitoring grafana -o jsonpath='{.data.admin-password}' | base64 -d ; echo

# Install Robusta
