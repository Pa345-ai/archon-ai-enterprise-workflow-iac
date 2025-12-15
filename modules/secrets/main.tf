resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.environment}-${var.application_name}-jwt_secret"
  description             = "JWT secret for ${var.application_name} in ${var.environment}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 7

  tags = {
    Name               = "${var.environment}-${var.application_name}-jwt_secret"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
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
  name                    = "${var.environment}-${var.application_name}-openai_api_key"
  description             = "OpenAI API key for ${var.application_name} in ${var.environment}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 0

  tags = {
    Name               = "${var.environment}-${var.application_name}-openai_api_key"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_secretsmanager_secret_version" "openai_api_key" {
  secret_id     = aws_secretsmanager_secret.openai_api_key.id
  secret_string = "dummy-openai-key" # Placeholder
}

resource "aws_secretsmanager_secret" "slack_token" {
  name                    = "${var.environment}-${var.application_name}-slack_token"
  description             = "Slack token for ${var.application_name} in ${var.environment}"
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = 0

  tags = {
    Name               = "${var.environment}-${var.application_name}-slack_token"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = "dummy-slack-token" # Placeholder
}
