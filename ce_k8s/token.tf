resource "volterra_token" "site" {
  name      = format("%s-rosa-clusters", var.project_prefix)
  namespace = "system"
}
