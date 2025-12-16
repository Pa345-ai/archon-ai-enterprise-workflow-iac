variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created IAM resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key that the IAM roles will be granted permission to use for decryption. This must be a valid KMS key ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid KMS key ARN."
  }
}

variable "core_task_secrets" {
  description = "A list of ARNs of the Secrets Manager secrets that the core ECS task role will be granted access to. Each element in the list must be a valid Secrets Manager secret ARN."
  type        = list(string)
}

variable "integrations_task_secrets" {
  description = "A list of ARNs of the Secrets Manager secrets that the integrations ECS task role will be granted access to. Each element in the list must be a valid Secrets Manager secret ARN."
  type        = list(string)
}
