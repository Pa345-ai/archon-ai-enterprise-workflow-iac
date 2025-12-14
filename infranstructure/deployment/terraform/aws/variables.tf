# Defines all variables that the CBA team may need to easily change for integration or scale
variable "aws_region" {
  description = "The AWS region to deploy the ARCHON AI platform into (e.g., ap-southeast-2 for Sydney)."
  type        = string
  default     = "ap-southeast-2"
  validation {
    condition     = contains(["ap-southeast-2", "us-east-1", "eu-west-1"], var.aws_region)
    error_message = "AWS region must be a secure, approved region for CBA deployments."
  }
}

variable "environment" {
  description = "The deployment environment for the ARCHON AI platform."
  type        = string
  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

variable "backend_image_uri" {
  description = "The URI for the backend (FastAPI/Python) Docker image in ECR. Must use an immutable tag (e.g., v1.0.0) and not ':latest'."
  type        = string
  validation {
    condition     = !strcontains(var.backend_image_uri, ":latest")
    error_message = "Docker image URI must not use ':latest'; use an immutable tag for security and reproducibility."
  }
}

variable "fargate_cpu" {
  description = "Fargate task CPU capacity in CPU units (e.g., 512, 1024, 2048). Must be within enterprise-approved ranges."
  type        = number
  default     = 1024
  validation {
    condition     = var.fargate_cpu >= 512 && var.fargate_cpu <= 2048
    error_message = "Fargate CPU must be between 512 and 2048 CPU units for enterprise compliance."
  }
}

variable "fargate_memory" {
  description = "Fargate task memory in MiB (e.g., 1024, 2048, 4096). Must be within enterprise-approved ranges."
  type        = number
  default     = 2048
  validation {
    condition     = var.fargate_memory >= 1024 && var.fargate_memory <= 4096
    error_message = "Fargate memory must be between 1024 and 4096 MiB for enterprise compliance."
  }
}

variable "alb_certificate_arn" {
  description = "The ARN of a valid AWS Certificate Manager (ACM) certificate for the ALB (e.g., for a CBA domain)."
  type        = string
  validation {
    condition     = length(var.alb_certificate_arn) > 0
    error_message = "ALB certificate ARN must not be empty for secure HTTPS enforcement."
  }
}

variable "application_name" {
  description = "The name of the application for tagging and governance purposes."
  type        = string
  default     = "ARCHON-AI"
  validation {
    condition     = length(var.application_name) > 0
    error_message = "Application name must not be empty for enterprise governance."
  }
}

variable "owner" {
  description = "The owner or team responsible for the deployment, for tagging and governance."
  type        = string
  validation {
    condition     = length(var.owner) > 0
    error_message = "Owner must not be empty for enterprise governance."
  }
}

variable "cost_center" {
  description = "The cost center associated with the deployment for financial tracking and governance."
  type        = string
  validation {
    condition     = length(var.cost_center) > 0
    error_message = "CostCenter must not be empty for enterprise governance."
  }
}

variable "allowed_ingress_cidrs" {
  description = "A list of approved CIDR blocks for ingress traffic to the ALB."
  type        = list(string)
  validation {
    condition = alltrue([
      for cidr in var.allowed_ingress_cidrs : cidr != "0.0.0.0/0"
    ]) || var.environment == "dev"
    error_message = "Ingress from '0.0.0.0/0' is not allowed in 'uat' or 'prod' environments."
  }
}
