variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "The deployment environment."
  type        = string
  default     = "prod"
}

variable "application_name" {
  description = "The name of the application."
  type        = string
  default     = "ARCHON-AI"
}

variable "owner" {
  description = "The owner of the application."
  type        = string
  default     = "ArchonTeam"
}

variable "cost_center" {
  description = "The cost center for the application."
  type        = string
  default     = "IT-12345"
}

variable "data_classification" {
  description = "The data classification of the application."
  type        = string
  default     = "Confidential"
}

variable "db_name" {
  description = "The name of the database."
  type        = string
  default     = "archondb_prod"
}

variable "alb_certificate_arn" {
  description = "The ARN of the ACM certificate for the ALB."
  type        = string
}

variable "backend_image_uri" {
  description = "The URI of the backend Docker image."
  type        = string
  default     = "nginx:1.21.6" # Placeholder
}

variable "alb_ingress_cidrs" {
  description = "The CIDR blocks to allow ingress from to the ALB."
  type        = list(string)
  default     = [] # Must be overridden in terraform.tfvars
}
