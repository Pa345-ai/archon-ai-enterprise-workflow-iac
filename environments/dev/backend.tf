terraform {
  backend "s3" {
    bucket         = "archon-ai-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "archon-ai-terraform-state-lock"
  }
}
