# Monitoring Module - variables.tf

variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "owner" {
  description = "The owner of the resources."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}
