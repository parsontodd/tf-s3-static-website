terraform {
  required_version = "~> 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Owner     = "parson"
      ManagedBy = "terraform-parson"
    }
  }
}