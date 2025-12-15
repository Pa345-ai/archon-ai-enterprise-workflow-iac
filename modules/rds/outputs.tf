output "db_instance_identifier" {
  description = "The identifier of the RDS instance."
  value       = aws_db_instance.main.identifier
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.main.endpoint
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance."
  value       = aws_db_instance.main.arn
}

output "master_user_secret_arn" {
  description = "The ARN of the master user secret."
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
