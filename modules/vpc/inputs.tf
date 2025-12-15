variable "aws_region" {
  description = "The AWS region."
  type        = string
}

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

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}
