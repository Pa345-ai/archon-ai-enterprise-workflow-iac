resource "random_password" "db_password_gen" {  # Renamed for consistency
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "ai_platform_db_password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({"password": random_password.db_password_gen.result})  # Updated reference
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name = "ai_platform_jwt_secret"
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({"secret": "placeholder-jwt-secret"})
}

resource "aws_secretsmanager_secret" "openai_key" {
  name = "ai_platform_openai_key"
}

resource "aws_secretsmanager_secret_version" "openai_key" {
  secret_id     = aws_secretsmanager_secret.openai_key.id
  secret_string = jsonencode({"key": "placeholder-openai-key"})
}

resource "aws_secretsmanager_secret" "slack_token" {
  name = "ai_platform_slack_token"
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = jsonencode({"token": "placeholder-slack-token"})
}
