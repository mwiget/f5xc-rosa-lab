resource "terraform_data" "cluster" {
  depends_on = [ terraform_data.reqs ]
  input = format("%s-%s", var.project_prefix, var.cluster_name)

  provisioner "local-exec" {
    command = <<-EOT
      rosa create cluster \
        --sts \
        --mode auto --yes \
        --watch \
        --cluster-name ${self.input} \
        --version ${var.openshift_version} \
        --role-arn ${data.aws_iam_role.Installer.arn} \
        --controlplane-iam-role ${data.aws_iam_role.ControlPlane.arn} \
        --worker-iam-role ${data.aws_iam_role.Worker.arn} \
        --support-role-arn ${data.aws_iam_role.Support.arn} \
        --multi-az yes \
        --region ${var.aws_region} \
        --replicas ${var.replicas} \
        --compute-machine-type t3.xlarge \
        --machine-cidr "10.0.0.0/16" \
        --service-cidr "172.30.0.0/16" \
        --pod-cidr "10.128.0.0/14" \
        --host-prefix 23
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rosa delete cluster --cluster ${self.output} --yes --watch"
  }
}

resource "terraform_data" "cluster-ready" {
  depends_on = [ terraform_data.cluster ]
  input = format("%s-%s", var.project_prefix, var.cluster_name)

  provisioner "local-exec" {
    command = "until rosa list cluster | grep ${self.input} | grep ready; do echo 'waiting for cluster to be ready ...' && sleep 10; done"
  }
}

resource "terraform_data" "cluster-admin" {
  depends_on = [ terraform_data.cluster-ready ]
  input = format("%s-%s", var.project_prefix, var.cluster_name)

  provisioner "local-exec" {
    command = "rosa create admin --cluster ${self.input} --password ${var.cluster_admin_password}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rosa delete admin --cluster ${self.output} --yes"
  }
}

resource "terraform_data" "oc-login" {
  depends_on = [ terraform_data.cluster-admin ]
  input = format("%s-%s", var.project_prefix, var.cluster_name)

  triggers_replace = [ timestamp() ]

  provisioner "local-exec" {
    command = "until oc login `rosa describe cluster --cluster ${self.input} --output json | jq -r '.api.url'` --username cluster-admin --password ${var.cluster_admin_password}; do echo 'waiting for cluster-admin to be ready ...' && sleep 60; done"
  }
}

