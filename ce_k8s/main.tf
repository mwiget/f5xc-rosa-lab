resource "local_file" "ce_k8s_cluster_yaml" {
  content  = local.ce_k8s_cluster_yaml
  filename = "./ce_k8s_cluster.yaml"
}

locals {
  ce_k8s_cluster_yaml = templatefile("./templates/ce_k8s.yaml", {
    cluster_name              = format("%s-%s", var.project_prefix, var.cluster_name),
    latitude                  = var.latitude,
    longitude                 = var.longitude,
    token                     = volterra_token.site.id,
    site_label                = format("vsite: %s-rosa-clusters", var.project_prefix)
    replicas                  = var.replicas,
    maurice_endpoint_url      = local. maurice_endpoint_url,
    maurice_mtls_endpoint_url = local.maurice_mtls_endpoint_url
  })
  site_get_uri_cluster = format("config/namespaces/system/sites/%s-%s", var.project_prefix, var.cluster_name)
  site_get_url_cluster = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5xc_api_url, local.site_get_uri_cluster)
}

resource "terraform_data" "ce-k8s-cluster" {
  depends_on = [ local_file.ce_k8s_cluster_yaml ]
  provisioner "local-exec" {
    command     = "oc apply -f ./ce_k8s_cluster.yaml"
  }
  provisioner "local-exec" {
    when        = destroy
    on_failure  = continue
    command     = "oc delete -f ./ce_k8s_cluster.yaml"
  }
}

resource "volterra_registration_approval" "cluster" {
  depends_on = [ terraform_data.ce-k8s-cluster ]
  count = var.replicas
  cluster_name  = format("%s-%s", var.project_prefix, var.cluster_name)
  cluster_size  = var.replicas > 1 ? 3 : 1
  retry = 10
  wait_time = 60
  hostname = format("vp-manager-%d", count.index)
}

resource "terraform_data" "check_site_status_cluster" {
  depends_on = [volterra_registration_approval.cluster]
  provisioner "local-exec" {
    command     = format("./scripts/check.sh %s %s %s", local.site_get_url_cluster, local.f5xc_api_token, local.f5xc_tenant)
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

resource "volterra_site_state" "decommission_when_delete_cluster" {
  depends_on = [volterra_registration_approval.cluster]
  name       = format("%s-%s", var.project_prefix, var.cluster_name)
  when       = "delete"
  state      = "DECOMMISSIONING"
  retry      = 5
  wait_time  = 60
}
