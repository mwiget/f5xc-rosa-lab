
## Create ROSA cluster

Couldn't find Terraform provider or module to fully deploy a ROSA cluster while building this
lab setup. https://github.com/terraform-redhat looks promising, but doesn't seem to be ready yet.

Hence local-exec provider is used to launch `rosa create cluster` and `rosa delete cluster` with
required arguments, including the required iam roles retrieved via aws_iam_role data resources.

The manifest then waits for the cluster to be ready and creates the cluster-admin user and executes
`oc login` to get the [kubeconfig](~/.kube/config). 

To get started, check and fullfill AWS prerequisites according to 
https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html.
The helper script [rosa-pre-reqs.sh](rosa-pre-reqs.sh) can be used to query AWS, particularly for the required
account roles, which are pulled in as data resource [rosa/iam.tf](rosa/iam.tf). The Terraform manifest is simply 
a wrapper around the 
[Red Hat OpenShift Service on AWS (ROSA) CLI, `rosa`](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-installing-rosa.html) and also requires the OpenShift CLI, `oc`, installed.

Copy [terraform.tfvars.example](terraform.tfvars.example) to terraform.tfvars and set the required AWS keys, region,
desired Openshift version and cluster-admin password along the cluster_name, owner and project_prefix.

In case you chose non-default iam role prefix ("ManagedOpenShift"), set also the variable "iam_role_prefix" to match
the iam role names you have. E.g. uses the default prefix:

```
$ rosa list account-roles
I: Fetching account roles
ROLE NAME                           ROLE TYPE      ROLE ARN                                                           OPENSHIFT VERSION  AWS Managed
ManagedOpenShift-ControlPlane-Role  Control plane  arn:aws:iam::000000000000:role/ManagedOpenShift-ControlPlane-Role  4.13               No
ManagedOpenShift-Installer-Role     Installer      arn:aws:iam::000000000000:role/ManagedOpenShift-Installer-Role     4.13               No
ManagedOpenShift-Support-Role       Support        arn:aws:iam::000000000000:role/ManagedOpenShift-Support-Role       4.13               No
ManagedOpenShift-Worker-Role        Worker         arn:aws:iam::000000000000:role/ManagedOpenShift-Worker-Role        4.13               No
```

Then do the usual:

```
terraform init
terraform plan
terraform apply
```

This will take a long time to complete, as it will wait for the cluster to be online, create the cluster-admin
user, log into the cluster and enable hugepages on worker nodes.


```
. . . 

terraform_data.oc-login: Still creating... [16m31s elapsed]
terraform_data.oc-login (local-exec): Login successful.

terraform_data.oc-login (local-exec): You have access to 98 projects, the list has been suppressed. You can list all projects with 'oc projects'

terraform_data.oc-login (local-exec): Using project "default".
terraform_data.oc-login: Creation complete after 16m35s [id=d0e39f58-29a6-9c0a-30b0-77bf58c3342c]
terraform_data.hugepages: Creating...
terraform_data.hugepages: Provisioning with 'local-exec'...
terraform_data.hugepages (local-exec): Executing: ["/bin/sh" "-c" "oc apply -f hugepages-tuned-bootime.yaml"]
terraform_data.hugepages (local-exec): tuned.tuned.openshift.io/hugepages created
terraform_data.hugepages: Creation complete after 4s [id=d5b7f034-d7d3-5f37-ac80-8cb4f911a44e]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

ControlPlane-Role = "arn:aws:iam::000000000000:role/ManagedOpenShift-ControlPlane-Role"
Installer-Role = "arn:aws:iam::000000000000:role/ManagedOpenShift-Installer-Role"
Support-Role = "arn:aws:iam::000000000000:role/ManagedOpenShift-Support-Role"
Worker-Role = "arn:aws:iam::000000000000:role/ManagedOpenShift-Worker-Role"
```

Check nodes and hugepages:

```
$ oc get nodes

NAME                                          STATUS                     ROLES          AGE   VERSION
ip-10-0-132-73.eu-north-1.compute.internal    Ready                      infra,worker   21m   v1.23.17+16bcd69
ip-10-0-156-213.eu-north-1.compute.internal   Ready                      master         45m   v1.23.17+16bcd69
ip-10-0-159-155.eu-north-1.compute.internal   Ready                      worker         38m   v1.23.17+16bcd69
ip-10-0-160-137.eu-north-1.compute.internal   Ready                      master         45m   v1.23.17+16bcd69
ip-10-0-163-144.eu-north-1.compute.internal   Ready                      worker         38m   v1.23.17+16bcd69
ip-10-0-165-7.eu-north-1.compute.internal     Ready,SchedulingDisabled   infra,worker   21m   v1.23.17+16bcd69
ip-10-0-198-228.eu-north-1.compute.internal   Ready                      worker         37m   v1.23.17+16bcd69
ip-10-0-204-251.eu-north-1.compute.internal   Ready                      master         45m   v1.23.17+16bcd69
ip-10-0-209-245.eu-north-1.compute.internal   Ready                      infra,worker   21m   v1.23.17+16bcd69
```

```
$ ../check-hugepages.sh

ip-10-0-132-73.eu-north-1.compute.internal  0
ip-10-0-159-155.eu-north-1.compute.internal  800Mi
ip-10-0-163-144.eu-north-1.compute.internal  800Mi
ip-10-0-165-7.eu-north-1.compute.internal  800Mi
ip-10-0-198-228.eu-north-1.compute.internal  800Mi
ip-10-0-209-245.eu-north-1.compute.internal  800Mi
```

It can take a few minutes until all worker nodes automatically rebooted for the hugepages to be activated.


Now the cluster is ready to deploy the F5 XC kubernetes site [../ce_k8s/](../ce_k8s/).




## Resources

- [Red Hat OpenShift Understanding ROSA](https://docs.openshift.com/rosa/rosa_architecture/rosa-understanding.html)
- [Red Hat OpenShift Service on AWS (ROSA)](https://aws.amazon.com/rosa/)
- [Create a ROSA cluster with STS using customizations](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa-sts-creating-a-cluster-with-customizations.html)
