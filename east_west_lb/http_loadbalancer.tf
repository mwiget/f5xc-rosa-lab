resource "volterra_http_loadbalancer" "k8s-site-demo" {
  name                            = format("%s-f5-httpd-demo", var.project_prefix)
  namespace                       = local.namespace_f5xc
  no_challenge                    = true
  domains                         = [ 
    "backend", format("backend.%s", local.namespace_f5xc) 
  ]

  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true

  advertise_custom {
    advertise_where {
      site {
        network   = "SITE_NETWORK_OUTSIDE"
        site {
          name      = format("%s-%s", var.project_prefix, var.cluster_name)
          namespace = "system"
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.backend.name
    }
    weight = 1
    priority = 1
  }

  http {
    dns_volterra_managed = false
  }

  depends_on = [ volterra_origin_pool.backend, volterra_namespace.backend ]
}

