variable "aws_region" {
  type        = string
  description = "AWS region name"
}

variable "project_prefix" {
  type        = string
  default     = "prefix"
}

variable "cluster_name" {
  type        = string
  default     = "rosa1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
} 

variable "owner" {}

variable "openshift_version" {
  type    = string
  default = "4.10.63"
}

variable "replicas" {
  type    = number
  default = 3
}

variable "iam_role_prefix" {
  type = string
  default = "ManagedOpenShift"
}

variable "cluster_admin_password" {
  type = string
  default = ""
}
