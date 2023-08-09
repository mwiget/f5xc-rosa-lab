variable "project_prefix" {
  type        = string
  default     = "prefix"
}

variable "cluster_name" {
  type        = string
  default     = "rosa1"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type = string
  default = ""
}

variable "f5xc_tenant" {
  type = string
}

variable "namespace" {
  type    = string
  default = "projectX"
}

variable "owner" {}

variable "replicas" {
  type    = number
  default = 3
}

variable "fqdn" {
  type    = string
  default = "service.domain.org"
}
