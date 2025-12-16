variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to the KMS key. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "existing_kms_key_arn" {
  description = "Optional: The ARN of an existing KMS key to use for all encryption. If not provided, a new KMS key will be created. This is for Bring-Your-Own-Key (BYOK) scenarios."
  type        = string
  default     = null

  validation {
    condition     = var.existing_kms_key_arn == null ? true : can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.existing_kms_key_arn))
    error_message = "The existing_kms_key_arn must be a valid KMS key ARN."
  }
}
