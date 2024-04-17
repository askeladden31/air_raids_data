variable "credentials" {
  description = "My Credentials"
  default     = "~/dtc_de/keys/my-creds.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "dtc-de-course-412311"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "europe-central2"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "europe-central2"
}

variable "bq_dwh" {
  description = "BigQuery dataset serving as data warehouse"
  #Update the below to what you want your dataset to be called
  default     = "air_raids_data"
}

variable "gcs_bucket_name" {
  description = "GCS bucket for storing raw data"
  #Update the below to a unique bucket name
  default     = "air_raids_data"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
