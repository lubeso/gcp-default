terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.6.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
