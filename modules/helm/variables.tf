# Google Cloud Provider configuration
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started
variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Default location for regional resources"
}

variable "zone" {
  type        = string
  description = "Default location for zonal resources"
}

# Implementation variables
variable "domain" {
  type        = string
  description = "Domain name"
}

variable "redirect_http" {
  type        = bool
  description = "Whether to redirect HTTP traffic to HTTPS"
  default     = true
}
