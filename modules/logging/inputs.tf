variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created logging resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC for which to enable Flow Logs. This must be a valid VPC ID (e.g., 'vpc-12345678')."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]+$", var.vpc_id))
    error_message = "The vpc_id must be a valid VPC ID (e.g., 'vpc-12345678')."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt the S3 bucket for access logs. This must be a valid KMS key ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.*$", var.kms_key_arn))
    error_message = "The kms_key_arn must be a valid KMS key ARN."
  }
}
