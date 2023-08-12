resource "volterra_namespace" "backend" {
  name = local.namespace_f5xc
}

resource "kubernetes_namespace" "frontend" {
  metadata {
    name = local.namespace_frontend
  }
  provider = kubernetes.rosa
}

resource "kubernetes_namespace" "backend" {
  metadata {
    name = local.namespace_backend
  }
  provider = kubernetes.rosa
}

resource "kubernetes_namespace" "f5xc" {
  metadata {
    name = local.namespace_f5xc
  }
  provider = kubernetes.rosa
}

output "namespace_frontend" {
  value = local.namespace_frontend
}
output "namespace_backend" {
  value = local.namespace_backend
}
output "namespace_f5xc" {
  value = local.namespace_f5xc
}
