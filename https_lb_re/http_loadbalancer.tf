resource "volterra_http_loadbalancer" "k8s-site-demo" {
  name                            = format("%s-f5-httpd-demo", var.project_prefix)
  namespace                       = local.namespace
  no_challenge                    = true
  domains                         = [var.fqdn]
  advertise_on_public_default_vip = true

  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true

  https_auto_cert {
    http_redirect = true
  }

  default_route_pools {
    pool {
      namespace = local.namespace
      name = volterra_origin_pool.op.name
    }
  }
  round_robin = true

  app_firewall {
    namespace = "shared"
    name      = "default"
  }

  enable_ip_reputation {
    ip_threat_categories = [ "SPAM_SOURCES", "NETWORK", "MOBILE_THREATS" ]
  }

  depends_on = [ volterra_origin_pool.op, volterra_namespace.ns ]
}
