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
