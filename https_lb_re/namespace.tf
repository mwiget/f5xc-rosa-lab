resource "volterra_namespace" "ns" {
  name = local.namespace
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = local.namespace
  }
  provider = kubernetes.rosa
}
