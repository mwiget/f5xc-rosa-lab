provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  timeout      = "30s"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  alias          = "rosa"
  #  config_context = "my-context"
}

