locals {
  # app.example.com => app-example
  ingress_name = join("-", slice(split(".", var.domains[0]), 0, length(split(".", var.domains[0])) - 1))
}

resource "google_compute_global_address" "app" {
  name = local.ingress_name
}

resource "google_compute_managed_ssl_certificate" "app" {
  name = local.ingress_name
  managed {
    domains = var.domains
  }
}

# https://github.com/terraform-google-modules/terraform-google-lb-http/tree/master/modules/serverless_negs
module "lb-http" {
  project              = var.project
  name                 = "hello-app"
  source               = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version              = "~> 4.4"
  ssl                  = true
  use_ssl_certificates = true
  ssl_certificates = [
    google_compute_managed_ssl_certificate.app.self_link
  ]
  create_address = false
  address        = google_compute_global_address.app.address
  backends = {
    default = {
      description            = null
      enable_cdn             = false
      custom_request_headers = null
      security_policy        = null

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = google_compute_region_network_endpoint_group.hello_service.id
        }
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}

output "ip_address" {
  value = google_compute_global_address.app.address
}
