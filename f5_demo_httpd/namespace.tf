resource "volterra_namespace" "ns" {
  name = var.namespace
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
  provider = kubernetes.rosa
}
