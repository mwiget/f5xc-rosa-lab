#!/bin/bash
namespace=$(terraform output -raw namespace)
serviceName=$(terraform output -raw service_name)
host=$(oc get route $serviceName -n $namespace -o json | jq -r ".spec.host")
echo "curl https://$host/txt ..."
echo ""
curl https://$host/txt
