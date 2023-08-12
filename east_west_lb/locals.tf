locals {
  namespace_frontend = format("%s-east-west", var.project_prefix)
  namespace_backend  = format("%s-east-west-be", var.project_prefix)
  namespace_f5xc     = format("%s-%s-east-west-be", var.project_prefix, var.cluster_name)
}
