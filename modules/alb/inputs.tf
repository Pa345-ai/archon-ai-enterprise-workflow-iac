variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created Application Load Balancer resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed. This must be a valid VPC ID (e.g., 'vpc-12345678')."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID (e.g., 'vpc-12345678')."
  }
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs where the ALB nodes will be placed. These subnets must have a route to an Internet Gateway."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the security group to associate with the ALB. This security group should control inbound traffic to the load balancer."
  type        = string
}

variable "alb_certificate_arn" {
  description = "The ARN of the ACM certificate to be used for the HTTPS listener on the ALB. This must be a valid ACM certificate ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/.*$", var.alb_certificate_arn))
    error_message = "The alb_certificate_arn must be a valid ACM certificate ARN."
  }
}

variable "access_logs_bucket_name" {
  description = "The name of the S3 bucket where the ALB will store its access logs. This bucket must exist and the ALB must have permission to write to it."
  type        = string
}
