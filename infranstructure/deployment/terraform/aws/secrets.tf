resource "random_password" "db_password_gen" {
  length      = var.db_password_length
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  validation {
    condition     = length(random_password.db_password_gen.result) >= 12
    error_message = "Generated password must meet enterprise complexity standards (at least 12 characters)."
  }
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.environment}-ai_platform_db_password"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({"password": random_password.db_password_gen.result})
}

resource "aws_secretsmanager_secret_rotation" "db_password" {
  secret_id           = aws_secretsmanager_secret.db_password.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn  # Assume defined elsewhere for rotation
  rotation_rules {
    automatically_after_days = var.secret_rotation_days
  }
}

resource "random_id" "jwt_secret_gen" {
  byte_length = var.jwt_secret_length
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name = "${var.environment}-ai_platform_jwt_secret"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = jsonencode({"secret": random_id.jwt_secret_gen.hex})
}

resource "aws_secretsmanager_secret_rotation" "jwt_secret" {
  secret_id           = aws_secretsmanager_secret.jwt_secret.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn  # Assume defined elsewhere for rotation
  rotation_rules {
    automatically_after_days = var.secret_rotation_days
  }
}

resource "random_id" "openai_key_gen" {
  byte_length = var.openai_key_length
}

resource "aws_secretsmanager_secret" "openai_key" {
  name = "${var.environment}-ai_platform_openai_key"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "openai_key" {
  secret_id     = aws_secretsmanager_secret.openai_key.id
  secret_string = jsonencode({"key": random_id.openai_key_gen.hex})
}

resource "aws_secretsmanager_secret_rotation" "openai_key" {
  secret_id           = aws_secretsmanager_secret.openai_key.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn  # Assume defined elsewhere for rotation
  rotation_rules {
    automatically_after_days = var.secret_rotation_days
  }
}

resource "random_id" "slack_token_gen" {
  byte_length = var.slack_token_length
}

resource "aws_secretsmanager_secret" "slack_token" {
  name = "${var.environment}-ai_platform_slack_token"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = jsonencode({"token": random_id.slack_token_gen.hex})
}

resource "aws_secretsmanager_secret_rotation" "slack_token" {
  secret_id           = aws_secretsmanager_secret.slack_token.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn  # Assume defined elsewhere for rotation
  rotation_rules {
    automatically_after_days = var.secret_rotation_days
  }
}

resource "random_pet" "db_user_gen" {
  length = 2
}

resource "aws_secretsmanager_secret" "db_host" {
  name = "${var.environment}-ai_platform_db_host"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = jsonencode({"host": aws_db_instance.postgres.endpoint})
  depends_on    = [aws_db_instance.postgres]
}

resource "aws_secretsmanager_secret" "db_name" {
  name = "${var.environment}-ai_platform_db_name"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = jsonencode({"name": var.db_name})
}

resource "aws_secretsmanager_secret" "db_user" {
  name = "${var.environment}-ai_platform_db_user"
  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = jsonencode({"user": random_pet.db_user_gen.id})
}
