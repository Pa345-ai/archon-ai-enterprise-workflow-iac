resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-jwt_secret"
  description             = "JWT secret for ${var.common_tags["Application"]} in ${var.common_tags["Environment"]}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-jwt_secret"
  })
}

resource "random_string" "jwt_secret" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = random_string.jwt_secret.result
}

resource "aws_secretsmanager_secret" "openai_api_key" {
  name                    = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-openai_api_key"
  description             = "OpenAI API key for ${var.common_tags["Application"]} in ${var.common_tags["Environment"]}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 0

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-openai_api_key"
  })
}

resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id     = aws_secretsmanager_secret.openai_api_key.id
  secret_string = "dummy-openai-key" # Placeholder
}

resource "aws_secretsmanager_secret" "slack_token" {
  name                    = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-slack_token"
  description             = "Slack token for ${var.common_tags["Application"]} in ${var.common_tags["Environment"]}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 0

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-slack_token"
  })
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = "dummy-slack-token" # Placeholder
}
