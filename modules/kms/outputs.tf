output "kms_key_id" {
  description = "The ID of the KMS key."
  value       = var.existing_kms_key_arn == null ? aws_kms_key.main[0].id : data.aws_kms_key.existing[0].id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key."
  value       = var.existing_kms_key_arn == null ? aws_kms_key.main[0].arn : data.aws_kms_key.existing[0].arn
}

data "aws_kms_key" "existing" {
  count  = var.existing_kms_key_arn != null ? 1 : 0
  key_id = var.existing_kms_key_arn
}
