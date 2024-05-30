terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.36.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
  required_version = ">=1.8.4"
}

provider "aws" {
  region     = var.region["virginia"]
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = var.tags
  }


}