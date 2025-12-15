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

variable "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The ID of the RDS security group."
  type        = string
}

variable "kms_key_id" {
  description = "The ID of the KMS key to use for encryption."
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database in GB."
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

variable "prevent_destroy" {
  description = "A boolean to prevent the database from being destroyed."
  type        = bool
  default     = false
}
