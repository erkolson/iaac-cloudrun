terraform {
  required_version = ">= 0.13"

  required_providers {
    google = ">= 3.0"
  }
}

provider "google" {
  project = var.project
}
