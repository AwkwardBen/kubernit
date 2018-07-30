#!/bin/sh
set -e

helm init --client-only

helm repo add charts http://127.0.0.1:8879

helm install charts/nginx-ingress

helm install charts/prometheus
helm install charts/alertmanager
helm install charts/grafana
helm install charts/prometheus-operator
helm install charts/kube-prometheus
