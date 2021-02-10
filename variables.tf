variable "project" {
  description = "Project ID location to deploy infrastructure"
}

variable "dev_user" {
  description = "Google account email address for app authentication"
  default = "me@example.com"
}

variable "public_access" {
  default = true
}

variable "domains" {
  type = list(string)
}

variable "region" {
  default = "us-central1"
}

variable "container_registry_location" {
  default = "gcr.io/cloudrun/hello"
}
