output "secret_arns" {
  description = "A map of the secret ARNs."
  value = {
    jwt_secret     = aws_secretsmanager_secret.jwt_secret.arn
    openai_api_key = aws_secretsmanager_secret.openai_api_key.arn
    slack_token    = aws_secretsmanager_secret.slack_token.arn
  }
}
