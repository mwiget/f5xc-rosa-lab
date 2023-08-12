resource "time_sleep" "wait_10_seconds" {
  depends_on      = [volterra_namespace.backend]
  create_duration = "10s"
}

resource "terraform_data" "ns-ready" {
  depends_on = [ time_sleep.wait_10_seconds ]
}

resource "volterra_healthcheck" "hc" {
  depends_on = [ terraform_data.ns-ready ]
  name      = format("%s-backend", var.project_prefix)
  namespace = volterra_namespace.backend.name

  http_health_check {
    use_origin_server_name = true
    path                   = "/txt"
  }
  healthy_threshold   = 2
  interval            = 15
  timeout             = 2
  unhealthy_threshold = 5
}

resource "volterra_origin_pool" "backend" {
  depends_on = [ terraform_data.ns-ready ]
  name                   = format("%s-backend", var.project_prefix)
  namespace              = volterra_namespace.backend.name
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 8080
  no_tls                 = true

  origin_servers {
    k8s_service {
      service_name  = format("%s.%s", kubernetes_deployment.backend.metadata[0].name, local.namespace_backend)
      vk8s_networks = true
      site_locator {
        site {
          name      = format("%s-%s", var.project_prefix, var.cluster_name)
          namespace = "system"
        }
      }
    }
  }

  healthcheck {
    name = format("%s-f5-httpd-demo", var.project_prefix)
  }
}


