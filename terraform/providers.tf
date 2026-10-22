# providers.tf

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "technova-terraform-state-6325128"  # Substitua SEURA pelo seu RA
    key            = "networking/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "technova-terraform-locks"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}