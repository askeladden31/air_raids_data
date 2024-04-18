terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_compute_instance" "default" {
  name         = "test-instance"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

   metadata = {
     startup-script = file("startup.sh")
   }
}



resource "google_storage_bucket" "data-lake" {
  name          = var.gcs_bucket_name
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



resource "google_bigquery_dataset" "dbt_production" {
  dataset_id = var.bq_dbt_prod
  location   = var.location
}

resource "google_bigquery_dataset" "dbt_development" {
  dataset_id = var.bq_dbt_dev
  location   = var.location
}

resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id = var.bq_dwh
  location   = var.location
}
