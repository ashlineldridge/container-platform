# We rely on GOOGLE_CREDENTIALS to point to the credentials file

terraform {
  backend "gcs" {
    bucket = "ashlin-terraform-state"
    prefix = "platform"
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  version = "~> 2.12"
}