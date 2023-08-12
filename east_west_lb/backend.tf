resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
    namespace = kubernetes_namespace.backend.id
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = "marcelwiget/f5-demo-httpd:openshift" # https://github.com/f5devcentral/f5-demo-httpd/pull/4
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
            value   = "backend"
          }
          env {
            name    = "F5DEMO_COLOR"
            value   = "a0bf37"        # green
          }
        }
      }
    }
  }
  provider = kubernetes.rosa
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "backend"
    namespace = kubernetes_namespace.backend.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.backend.metadata.0.labels.app
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

