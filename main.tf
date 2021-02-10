resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

resource "google_service_account" "hello_service" {
  account_id   = "hello-service"
  display_name = "Cloud Run Hello Service Account"
}

resource "google_cloud_run_service" "hello_service" {
  name     = "hello"
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.hello_service.email

      containers {
        image = var.container_registry_location
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run]
}

resource "google_cloud_run_service_iam_member" "all_users" {
  count    = var.public_access ? 1 : 0
  service  = google_cloud_run_service.hello_service.name
  location = google_cloud_run_service.hello_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_binding" "only_me" {
  count    = var.public_access ? 0 : 1
  service  = google_cloud_run_service.hello_service.name
  location = google_cloud_run_service.hello_service.location
  role     = "roles/run.invoker"
  members = [
    "user:${var.dev_user}"
  ]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group#example-usage---region-network-endpoint-group-cloudrun
resource "google_compute_region_network_endpoint_group" "hello_service" {
  name                  = "hello-service"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_service.hello_service.location
  cloud_run {
    service = google_cloud_run_service.hello_service.name
  }
}



output "cloudrun_url" {
  value = google_cloud_run_service.hello_service.status[0].url
}
