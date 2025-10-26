terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.46"
    }
  }
}




#provide authentication here
provider "aws" {
  region = "us-east-1"
}