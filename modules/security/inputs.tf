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

variable "aws_region" {
  description = "The AWS region."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  type        = list(string)
}

variable "allowed_ingress_cidrs" {
  description = "A list of approved CIDR blocks for ingress traffic to the ALB."
  type        = list(string)
}
