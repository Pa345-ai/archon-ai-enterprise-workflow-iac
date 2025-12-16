variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created Secrets Manager secrets. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "kms_key_id" {
  description = "The ID of the KMS key used to encrypt the secrets. This must be a valid KMS key ID."
  type        = string
}
