resource "kubernetes_deployment" "f5-demo-httpd" {
  metadata {
    name = "f5-demo-httpd"
    namespace = kubernetes_namespace.ns.id
    labels = {
      app = "f5-demo-httpd"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "f5-demo-httpd"
      }
    }

    template {
      metadata {
        labels = {
          app = "f5-demo-httpd"
        }
      }

      spec {
        container {
          image = "f5devcentral/f5-demo-httpd:openshift"
          name  = "f5-demo-httpd"

          liveness_probe {
            http_get {
              path = "/txt"
              port = 8080

              http_header {
                name = "X-Custom-Header"
                value = "liveness_probe"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 5
          }

          env {
            name    = "F5DEMO_APP"
            value   = "website"
          }
          env {
            name    = "F5DEMO_NODENAME"
            value   = format("%s-%s", var.project_prefix, var.cluster_name)
          }
#          env {
#            name    = "F5DEMO_COLOR"
#            value   = "ed7b0c"        # orange
#          }
        }
      }
    }
  }
  provider = kubernetes.rosa
}

resource "kubernetes_service" "ks" {
  metadata {
    name = "f5-demo-httpd"
    namespace = kubernetes_namespace.ns.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.f5-demo-httpd.metadata.0.labels.app
    }
    session_affinity = "None"
    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
  provider = kubernetes.rosa
}

resource "terraform_data" "route" {
  depends_on = [ kubernetes_service.ks ]

  input = {
    service_name = kubernetes_service.ks.metadata[0].name
    namespace    = local.namespace
  }

  provisioner "local-exec" {
    command   = "oc create route edge --service=${self.input.service_name} --insecure-policy=Redirect -n ${self.input.namespace}"
  }

  provisioner "local-exec" {
    when      = destroy
    command   = "oc delete route ${self.input.service_name} -n ${self.input.namespace}"
  }
}

output "service_name" {
  value = kubernetes_service.ks.metadata[0].name
}
