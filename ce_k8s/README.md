
## Deploy F5 XC Kubernetes Site

This creates a F5 XC site token and applies the updated ce_k8s template to the cluster 
using `oc`, then accepts the pending registrations of the 3 replicas and waits for the site
to be online.

To deploy, copy [terraform.tfvars.example](terraform.tfvars.example) to terraform.tfvars and
set the F5 XC API and Token credentials as well as the latitude and longitude of the site.

Then do the usual:

```
terraform init
terraform plan
terraform apply
```

Example run

```
. . . 


terraform_data.check_site_status_cluster (local-exec): Status: UPGRADING --> Waiting...

terraform_data.check_site_status_cluster (local-exec): Status: ONLINE --> Wait 30 secs and check status again...

terraform_data.check_site_status_cluster: Still creating... [12m0s elapsed]
terraform_data.check_site_status_cluster: Still creating... [12m10s elapsed]
terraform_data.check_site_status_cluster: Still creating... [12m20s elapsed]
terraform_data.check_site_status_cluster (local-exec): Done
terraform_data.check_site_status_cluster: Creation complete after 12m28s [id=ce2f7dcb-220a-3fba-96a7-b46fd4e31941]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
```

Check pods in ves-system namespace:

```
oc get pods -n ves-system -o wide

NAME                          READY   STATUS    RESTARTS        AGE
etcd-0                        2/2     Running   0               15m
etcd-1                        2/2     Running   0               15m
etcd-2                        2/2     Running   0               15m
prometheus-7659d5c4c8-hghxc   5/5     Running   0               14m
ver-0                         17/17   Running   0               14m
ver-1                         17/17   Running   0               11m
ver-2                         17/17   Running   0               7m55s
volterra-ce-init-49j9p        1/1     Running   0               20m
volterra-ce-init-lpkjm        1/1     Running   0               20m
volterra-ce-init-zzbhm        1/1     Running   0               20m
vp-manager-0                  1/1     Running   3 (4m22s ago)   17m
vp-manager-1                  1/1     Running   2 (15m ago)     17m
vp-manager-2                  1/1     Running   2 (16m ago)     18m
```

## Resources

- [Create Kubernetes Site](https://docs.cloud.f5.com/docs/how-to/site-management/create-k8s-site)
- [ce_k8s manifest template git repo](https://gitlab.com/volterra.io/volterra-ce/-/tree/master/k8s)
