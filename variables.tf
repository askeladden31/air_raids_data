variable "credentials" {
  description = "Credentials for running terraform"
  default     = "./keys/key.json"
}


variable "project" {
  description = "Project"
  default     = "dtc-de-course-412311"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default = "us-east1"
}

variable "location" {
  description = "Required for buckets and datasets"
  #Update the below to your desired location
  default = "us-east1"
}

variable "zone" {
  description = "Required for VM instance"
  #Update the below to your desired zone
  default = "us-east1-b"
}

variable "gcs_bucket_name" {
  description = "GCS bucket for storing raw data"
  #Update the below to a unique bucket name
  default = "air_raids_data"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}

variable "bq_dwh" {
  description = "BigQuery dataset serving as data warehouse"
  #Update the below to what you want your dataset to be called
  default = "air_raids_data"
}

variable "bq_dbt_dev" {
  description = "BigQuery dataset serving as data warehouse"
  #Update the below to what you want your dataset to be called
  default = "air_raids_data_dbt"
}

variable "bq_dbt_prod" {
  description = "BigQuery dataset serving as data warehouse"
  #Update the below to what you want your dataset to be called
  default = "air_raids_data_dbt_prod"
}
