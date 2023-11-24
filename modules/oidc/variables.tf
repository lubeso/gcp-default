# Google Cloud Provider configuration
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started
variable "project" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Default location for regional resources"
  default     = "us-east4"
}

variable "zone" {
  type        = string
  description = "Default location for zonal resources"
  default     = "us-east4-c"
}

# Implementation variables
variable "workload_identity_pool" {
  type = object({
    id           = string
    display_name = optional(string)
    disabled     = optional(bool, false)
  })
  description = "Required information for the Workload Identity Pool"
}

variable "workload_identity_pool_provider" {
  type = object({
    disabled            = optional(bool, false)
    attribute_condition = string
    attribute_mapping   = optional(map(string), { "google.subject" = "assertion.sub" })
    oidc                = object({ issuer_uri = string })
  })
  description = "Required information for the Workload Identity Pool Provider"
}

variable "service_account" {
  type = object({
    roles             = list(string)
    principal_subject = string
  })
  description = "Required information for the impersonated service account"
}
