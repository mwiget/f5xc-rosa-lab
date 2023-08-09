#!/usr/bin/env bash

set -e  # fail will cause the shell script to exit

echo "Query the AWS API to verify if the AWS CLI is installed and configured correctly:"
aws sts get-caller-identity
echo ""
echo "Query rosa version:"
rosa version
echo ""
echo "Verify if you are logged in successfully and check your credentials:"
rosa whoami
echo ""
echo "Verify if the oc CLI is installed correctly:"
rosa verify openshift-client
echo ""
echo "list ocm-role"
rosa list ocm-role
echo ""
echo "list user-role"
rosa list user-role
echo ""
echo "list account-roles (requires ControlPlane, Installer, Support and Worker Roles)"
rosa list account-roles
