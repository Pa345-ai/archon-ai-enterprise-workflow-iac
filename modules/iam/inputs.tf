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

variable "kms_key_arn" {
  description = "The ARN of the KMS key."
  type        = string
}

variable "core_task_secrets" {
  description = "A list of secret ARNs for the core task to access."
  type        = list(string)
}

variable "integrations_task_secrets" {
  description = "A list of secret ARNs for the integrations task to access."
  type        = list(string)
}
