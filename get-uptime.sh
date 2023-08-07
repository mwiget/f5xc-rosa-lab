#!/bin/bash
nodes=$(kubectl get nodes -o json| jq -r '.items[].metadata.name')
#echo $nodes ...
echo ""
for node in $nodes; do
  echo -ne "$node \t"
  oc debug node/$node -- chroot /host uptime 2>/dev/null
done
