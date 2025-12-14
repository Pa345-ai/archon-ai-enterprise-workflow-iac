# Database Module - variables.tf

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

variable "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  type        = list(string)
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database."
  type        = number
}

variable "db_instance_class" {
  description = "The instance class for the database."
  type        = string
}

variable "db_name" {
  description = "The name of the database."
  type        = string
}

variable "db_security_group_id" {
  description = "The ID of the database security group."
  type        = string
}

variable "db_backup_retention_period" {
  description = "The backup retention period for the database."
  type        = number
}

variable "db_password_length" {
  description = "The length of the database password."
  type        = number
}

variable "jwt_secret_length" {
  description = "The length of the JWT secret."
  type        = number
}

variable "openai_key_length" {
  description = "The length of the OpenAI key."
  type        = number
}

variable "slack_token_length" {
  description = "The length of the Slack token."
  type        = number
}
