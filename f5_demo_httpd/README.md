## f5-demo-httpd deployment

This project creates a [F5 Demo httpd](https://github.com/f5devcentral/f5-demo-httpd)
deployment on the ROSA cluster in a namespace and publishes it securely via F5 XC load balancer
to the Internet on the FQDN provided via TF variable.


To deploy, copy [terraform.tfvars.example](terraform.tfvars.example) to terraform.tfvars and
set the F5 XC API and Token credentials as well as fqdn, which must be a subdomain of an 
already delegated domain in your F5 XC tenant.

Then do the usual:

```
terraform init
terraform plan
terraform apply
```

Check demo pods:

```
$ oc get pod -n marcel-rosa1

NAME                             READY   STATUS    RESTARTS   AGE
f5-demo-httpd-6487779959-c2kq7   1/1     Running   0          50m
f5-demo-httpd-6487779959-pppkk   1/1     Running   0          50m
f5-demo-httpd-6487779959-w9xrv   1/1     Running   0          50m
```

Check services:

```
$ oc get services -n marcel-rosa1
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
f5-demo-httpd   ClusterIP   172.30.174.22   <none>        8080/TCP   50m
```

Check reachability from Internet:

```
$ curl https://rosa1.edge.mwlabs.net/txt

================================================
 ___ ___   ___                    _
| __| __| |   \ ___ _ __  ___    /_\  _ __ _ __
| _||__ \ | |) / -_) '  \/ _ \  / _ \| '_ \ '_ \ 
|_| |___/ |___/\___|_|_|_\___/ /_/ \_\ .__/ .__/
                                      |_|  |_|
================================================

      Node Name: marcel-rosa1
     Short Name: f5-demo-httpd-6487779959-c2kq7

      Server IP: 10.129.2.58
    Server Port: 8080

      Client IP: 10.131.0.22
    Client Port: 51205

Client Protocol: HTTP
 Request Method: GET
    Request URI: /txt

    host_header: f5-demo-httpd.marcel-rosa1
     user-agent: curl/8.1.2
x-forwarded-for: 212.51.142.105
```


