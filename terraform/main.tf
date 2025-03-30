terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "ultra-marathon-bucket" {
  name          = "${var.project}_${var.gcs_bucket_name}"
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}

# # VM instance
# resource "google_compute_instance" "vm_instance" {
#   name          = "airflow-instance"
#   project       = var.project
#   machine_type  = "e2-standard-4"
#   zone          = var.region

#   boot_disk {
#     initialize_params {
#       image = var.vm_image
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral public IP
#     }
#   }
# }