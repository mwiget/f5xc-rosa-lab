#!/bin/bash
set -e
namespace_frontend=$(terraform output -raw namespace_frontend)
namespace_f5xc=$(terraform output -raw namespace_f5xc)
namespace_backend=$(terraform output -raw namespace_backend)
serviceName=$(terraform output -raw service_name)
#echo namespace frontend=$namespace_frontend f5xc=$namespace_f5xc backend=$namespace_backend
#echo serviceName=$serviceName

echo ""
echo "frontend services on namespace $namespace_frontend:"
oc get services -n $namespace_frontend

echo ""
echo "services provided by F5XC LB on namespace $namespace_f5xc:"
oc get services -n $namespace_f5xc

echo ""
echo "backend services on namespace $namespace_backend:"
oc get services -n $namespace_backend

host=$(oc get route $serviceName -n $namespace_frontend -o json | jq -r ".spec.host")

echo "curl https://$host/txt ..."
echo ""
curl https://$host/txt

echo ""
echo "checking backend connection via CE LB ..."
echo "curl https://$host/backend/ ..."
curl https://$host/backend/

