variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "owner" {
  description = "The owner of the application."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the application."
  type        = string
}

variable "data_classification" {
  description = "The data classification of the application."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "alb_certificate_arn" {
  description = "The ARN of the ACM certificate for the ALB."
  type        = string
}

variable "access_logs_bucket_name" {
  description = "The name of the S3 bucket for ALB access logs."
  type        = string
}
