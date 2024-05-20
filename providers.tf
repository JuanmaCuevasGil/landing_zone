terraform {
  required_providers {
    aws = {
      version = "= 5.33.0"
    }
  }
}

# Brainboard aliases for AWS regions
provider "aws" {
  alias  = "eu-north-1"
  region = "eu-north-1"
}
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"
}
