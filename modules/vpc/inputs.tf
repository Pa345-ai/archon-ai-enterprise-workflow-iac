variable "aws_region" {
  description = "The AWS region where the VPC and associated resources will be deployed. This should be a valid AWS region identifier (e.g., 'us-east-1')."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "The aws_region must be a valid AWS region identifier (e.g., 'us-east-1')."
  }
}

variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "The primary IPv4 CIDR block for the VPC. This should be a valid CIDR notation (e.g., '10.0.0.0/16') and should not overlap with any other networks that this VPC might need to connect to."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The vpc_cidr must be a valid CIDR notation (e.g., '10.0.0.0/16')."
  }
}

variable "public_subnet_cidrs" {
  description = "A list of IPv4 CIDR blocks to use for creating public subnets. Each CIDR block must be a subset of the main VPC CIDR block and should not overlap with other subnets."
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Each value in public_subnet_cidrs must be a valid CIDR notation."
  }
}

variable "private_subnet_cidrs" {
  description = "A list of IPv4 CIDR blocks to use for creating private subnets. Each CIDR block must be a subset of the main VPC CIDR block and should not overlap with other subnets."
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "Each value in private_subnet_cidrs must be a valid CIDR notation."
  }
}
