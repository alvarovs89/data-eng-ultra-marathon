variable "credentials" {
  description = "My credentials"
  default     = "../keys/my-creds.json"
}

variable "project" {
  description = "Project"
  default     = "de-zoomcamp-ultra-marathon"
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "australia-southeast1"
  type = string
}
variable "location" {
  description = "Project Location"
  default     = "australia-southeast1"
}

variable "gcs_storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default = "STANDARD"
}


variable "bq_dataset_name" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  default     = "ultra_marathon_dataset"
}

variable "gcs_bucket_name" {
  description = "My storage bucket name"
  default     = "ultra-marathon-bucket"
}

variable "vm_image" {
  description = "Base image for your Virtual Machine."
  type = string
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}