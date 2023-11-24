# Terraform Cloud configuration
variable "terraform_organization_id" {
  type        = string
  description = "Terraform Cloud organization ID"
}

variable "terraform_workspace_id" {
  type        = string
  description = "Terraform Cloud default workspace ID"
}

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

# GitHub configuration
variable "github_owner_id" {
  type        = string
  description = "Unique identifier for the GitHub Organization"
}

variable "github_repository_id" {
  type        = string
  description = "Unique identifier for the GitHub repository"
}

# Miscellaneous
variable "domain" {
  type        = string
  description = "Domain name"
}
