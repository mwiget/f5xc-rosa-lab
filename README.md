#f5xc-rosa-lab

## Overview

Deploy [F5 XC Kubernetes Site](https://docs.cloud.f5.com/docs/how-to/site-management/create-k8s-site) 
on [Red Hat OpenShift Service on AWS (ROSA)](https://aws.amazon.com/rosa/) with Terraform. 

This repo contains two seperate Terraform projects:

1. [Create a ROSA cluster with STS using customizations](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa-sts-creating-a-cluster-with-customizations.html): Folder [rosa](rosa)

    Before running it, check and fullfill AWS prerequisites according to https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html.
    The helper script [rosa-pre-reqs.sh](rosa-pre-reqs.sh) can be used to query AWS, particularly for the required
    account roles, which are pulled in as data resource [rosa/iam.tf](rosa/iam.tf). The Terraform manifest is simply 
    a wrapper around the 
    [Red Hat OpenShift Service on AWS (ROSA) CLI, `rosa`](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-installing-rosa.html) and also requires the OpenShift CLI, `oc`, installed.

    The user `cluster-admin` is created and used to log into the cluster (storing kubeconfig in ~/.kube/config) and 
   400 2M Hugepages are automatically assigned to worker nodes as a final step of the ROSA deployment. 

2. Deploy redundant F5 XC Kubernetes Site (as a Pod) on the ROSA cluster: Folder [ce_k8s](ce_k8s)

    This creates a F5 XC site token and deploys a customized version of [ce_k8s.yml](https://gitlab.com/volterra.io/volterra-ce/-/blob/master/k8s/ce_k8s.yml) with 3 replicas, accepts the registrations and waits for the site to be online.
    Once complete, the deployed pods in ves-sytem can be listed using `oc get pods -n ves-system`.

##Resources

(https://docs.openshift.com/rosa/rosa_architecture/rosa-understanding.html)



