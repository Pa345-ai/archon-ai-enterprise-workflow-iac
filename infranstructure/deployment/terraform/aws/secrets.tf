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

resource "random_id" "jwt_secret_gen" {
  byte_length = 32
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name = "ai_platform_jwt_secret"
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({"secret": random_id.jwt_secret_gen.hex})
}

resource "random_id" "openai_key_gen" {
  byte_length = 32
}

resource "aws_secretsmanager_secret" "openai_key" {
  name = "ai_platform_openai_key"
}

resource "aws_secretsmanager_secret_version" "openai_key" {
  secret_id     = aws_secretsmanager_secret.openai_key.id
  secret_string = jsonencode({"key": random_id.openai_key_gen.hex})
}

resource "random_id" "slack_token_gen" {
  byte_length = 32
}

resource "aws_secretsmanager_secret" "slack_token" {
  name = "ai_platform_slack_token"
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = jsonencode({"token": random_id.slack_token_gen.hex})
}

resource "random_pet" "db_user_gen" {
  length = 2
}

resource "aws_secretsmanager_secret" "db_host" {
  name = "ai_platform_db_host"
}

resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = jsonencode({"host": aws_db_instance.postgres.endpoint})
}

resource "aws_secretsmanager_secret" "db_name" {
  name = "ai_platform_db_name"
}

resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = jsonencode({"name": "aiplatformdb"})
}

resource "aws_secretsmanager_secret" "db_user" {
  name = "ai_platform_db_user"
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = jsonencode({"user": random_pet.db_user_gen.id})
}
