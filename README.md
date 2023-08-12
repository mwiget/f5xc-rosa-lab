## Overview

Deploy [F5 XC Kubernetes Site](https://docs.cloud.f5.com/docs/how-to/site-management/create-k8s-site) 
on [Red Hat OpenShift Service on AWS (ROSA)](https://aws.amazon.com/rosa/) with Terraform. Optionally
deploy a demo httpd pod to the Internet via F5 XC.

This repo contains two seperate Terraform projects:

1. [Create a ROSA cluster with STS using customizations](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa-sts-creating-a-cluster-with-customizations.html): Folder [rosa](rosa)

    Before running it, check and fullfill AWS prerequisites according to https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html.
    The helper script [rosa-pre-reqs.sh](rosa-pre-reqs.sh) can be used to query AWS, particularly for the required
    account roles, which are pulled in as data resource [rosa/iam.tf](rosa/iam.tf). The Terraform manifest is simply 
    a wrapper around the 
    [Red Hat OpenShift Service on AWS (ROSA) CLI, `rosa`](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-installing-rosa.html) and also requires the OpenShift CLI, `oc`, installed.

    The user `cluster-admin` is created and used to log into the cluster (storing kubeconfig in ~/.kube/config) and 
   [400 2M Hugepages](rosa/hugepages-tuned-bootime.yaml) are automatically assigned to worker nodes as a final step of the ROSA deployment. 

2. Deploy redundant F5 XC Kubernetes Site (as a Pod) on the ROSA cluster: Folder [ce_k8s](ce_k8s)

    This creates a F5 XC site token and deploys a customized version of [ce_k8s.yml](https://gitlab.com/volterra.io/volterra-ce/-/blob/master/k8s/ce_k8s.yml) with 3 replicas, accepts the registrations and waits for the site to be online.
    Once complete, the deployed pods in ves-sytem can be listed using `oc get pods -n ves-system`.

3. Deploy HTTPS LB with auto cert via RE for f5-demo-httpd pod on the cluster and publish it on the Internet: Folder [https_lb_re](https_lb_re)

    This requires an existing delegated domain present in your F5 XC tenant, which the chosen FQDN is a subomdain.
    See [Domain Delegation](https://docs.cloud.f5.com/docs/how-to/app-networking/domain-delegation) for details.

4. Deploy f5-demo-httpd on the cluster as frontend and backend (separate namespaces) and publish frontend via Openshift 
ingress operator to the Internet: Folder [east_west_lb](east_west_lb). Backend service is connected to frontend via F5 XC
LB/origin pool.

    No prerequisites regarding delegated domain, as the service is published at <service_name>.apps.<cluster_name>.*.p1.openshiftapps.com.


## Resources

- [Red Hat OpenShift Understanding ROSA](https://docs.openshift.com/rosa/rosa_architecture/rosa-understanding.html)
- [How to deploy a web service on OpenShift](https://www.redhat.com/sysadmin/deploy-web-service-openshift)
