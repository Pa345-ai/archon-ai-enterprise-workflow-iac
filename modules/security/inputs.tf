variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created security resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created. This must be a valid VPC ID (e.g., 'vpc-12345678')."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID (e.g., 'vpc-12345678')."
  }
}

variable "aws_region" {
  description = "The AWS region where the resources are deployed. This is required for the VPC endpoint service name."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the VPC endpoint for Secrets Manager will be created. These must be valid subnet IDs."
  type        = list(string)
}

variable "allowed_ingress_cidrs" {
  description = "A list of IPv4 CIDR blocks that are permitted to access the Application Load Balancer. For production, this should be a restrictive set of IPs."
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.allowed_ingress_cidrs : can(cidrnetmask(cidr))])
    error_message = "Each value in allowed_ingress_cidrs must be a valid CIDR notation."
  }
}
