# Defines the required providers and versions for ARCHON AI
terraform {
  backend "s3" {
    bucket         = "archon-ai-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "archon-ai-terraform-state-lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  # The region is passed in via the variables file
  region = var.aws_region
}
