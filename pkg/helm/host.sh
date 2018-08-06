#!/bin/sh
set -e

for chart in $(ls charts/); do
  helm package charts/$chart
done

helm serve --repo-path . --address 127.0.0.1:8879
