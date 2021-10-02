# This file contains the TF configuration,
# All resources are deployed via separate files/modules such as _vpc.tf

provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12.21"

  backend "s3" {
    bucket = "state-byoi--822101501359"
    key    = "terraform-remote-state"
    region = "eu-west-2"
  }
}

