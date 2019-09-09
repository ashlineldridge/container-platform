terraform {
  backend "s3" {
    bucket = "ashlin-terraform-state"
    key = "platform/terraform.tfstate"
  }
}

provider "aws" {
  region  = var.region
  version = "~> 2.0"
}
