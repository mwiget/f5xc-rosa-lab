resource "terraform_data" "hugepages" {
  depends_on = [ terraform_data.oc-login ]
  input = format("%s-%s", var.project_prefix, var.cluster_name)

  triggers_replace = [ timestamp() ]

  provisioner "local-exec" {
    command = "oc apply -f hugepages-tuned-bootime.yaml"
  }
}


