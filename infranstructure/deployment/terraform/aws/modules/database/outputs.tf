# Database Module - outputs.tf

output "db_user_secret_arn" {
  description = "The ARN of the DB user secret."
  value       = aws_secretsmanager_secret.db_user.arn
}

output "db_password_secret_arn" {
  description = "The ARN of the DB password secret."
  value       = aws_secretsmanager_secret.db_password.arn
}

output "db_host_secret_arn" {
  description = "The ARN of the DB host secret."
  value       = aws_secretsmanager_secret.db_host.arn
}

output "db_name_secret_arn" {
  description = "The ARN of the DB name secret."
  value       = aws_secretsmanager_secret.db_name.arn
}

output "jwt_secret_arn" {
  description = "The ARN of the JWT secret."
  value       = aws_secretsmanager_secret.jwt_secret.arn
}

output "openai_key_secret_arn" {
  description = "The ARN of the OpenAI key secret."
  value       = aws_secretsmanager_secret.openai_key.arn
}

output "slack_token_secret_arn" {
  description = "The ARN of the Slack token secret."
  value       = aws_secretsmanager_secret.slack_token.arn
}
