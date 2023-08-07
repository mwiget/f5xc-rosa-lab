#!/usr/bin/env bash

nodes=$(kubectl get nodes -l node-role.kubernetes.io/worker -o json| jq -r '.items[].metadata.name')
echo ""
for node in $nodes; do
  echo -n "$node  "
  oc get node $node -o jsonpath="{.status.allocatable.hugepages-2Mi}"
  echo ""
done
