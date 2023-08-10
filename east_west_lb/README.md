## East-west LB Example

Deploy f5-demo-httpd on the cluster and publish it via Openshift ingress operator to the Internet.

To deploy, copy [terraform.tfvars.example](terraform.tfvars.example) to terraform.tfvars and
set the F5 XC API and Token credentials as well as fqdn, which must be a subdomain of an 
already delegated domain in your F5 XC tenant.

Then do the usual:

```
terraform init
terraform plan
terraform apply
```

Validate the published service via

```
$ ./validate.sh

curl https://f5-demo-httpd-mw-rosa1-east-west.apps.mw-rosa1.2bpt.p1.openshiftapps.com/txt ...   

================================================
 ___ ___   ___                    _
| __| __| |   \ ___ _ __  ___    /_\  _ __ _ __
| _||__ \ | |) / -_) '  \/ _ \  / _ \| '_ \ '_ \ 
|_| |___/ |___/\___|_|_|_\___/ /_/ \_\ .__/ .__/
                                      |_|  |_|
================================================

      Node Name: mw-rosa1
     Short Name: f5-demo-httpd-7479f7999f-p5rzn

      Server IP: 10.129.2.50
    Server Port: 8080

      Client IP: 10.130.2.16
    Client Port: 57966

Client Protocol: HTTP
 Request Method: GET
    Request URI: /txt

    host_header: f5-demo-httpd-mw-rosa1-east-west.apps.mw-rosa1.2bpt.p1.openshiftapps.com
     user-agent: curl/8.1.2
x-forwarded-for: 212.51.142.52
```
 


## Resources

- [How to deploy a web service on OpenShift](https://www.redhat.com/sysadmin/deploy-web-service-openshift)
