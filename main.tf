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
  name         = "final-project"
  machine_type = "e2-standard-4"
  zone         = var.zone

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
    startup-script = templatefile("./startup.tpl", {
      project         = var.project,
      region          = var.region,
      location        = var.location,
      gcs_bucket_name = var.gcs_bucket_name,
      bq_dwh          = var.bq_dwh,
      bq_dbt_dev      = var.bq_dbt_dev,
      bq_dbt_prod     = var.bq_dbt_prod,
      credentials     = file(var.credentials)
    })
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
