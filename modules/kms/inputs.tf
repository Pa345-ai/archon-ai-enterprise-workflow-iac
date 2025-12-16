variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to the KMS key. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}
