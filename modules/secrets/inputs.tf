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

variable "kms_key_id" {
  description = "The ID of the KMS key to use for encryption."
  type        = string
}
