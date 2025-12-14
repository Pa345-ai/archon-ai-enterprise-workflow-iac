# Database Module - main.tf

resource "aws_db_subnet_group" "default" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
    Application = var.application_name
  }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-ai-platform-db"
  allocated_storage    = var.db_allocated_storage
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = random_password.db_user.result
  password             = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.db_security_group_id]
  backup_retention_period = var.db_backup_retention_period
  multi_az             = true
  publicly_accessible  = false
  storage_encrypted    = true
  kms_key_id           = aws_kms_key.rds.key_id
  skip_final_snapshot  = false

  tags = {
    Name        = "${var.environment}-ai-platform-db"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption in ${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.environment}-rds-key"
  target_key_id = aws_kms_key.rds.key_id
}

resource "random_password" "db_password" {
  length  = var.db_password_length
  special = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.environment}-db-password"
  description             = "Database password for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

resource "random_password" "db_user" {
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "db_user" {
  name                    = "${var.environment}-db-user"
  description             = "Database username for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = random_password.db_user.result
}

resource "aws_secretsmanager_secret" "db_host" {
  name                    = "${var.environment}-db-host"
  description             = "Database host for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_host" {
  secret_id     = aws_secretsmanager_secret.db_host.id
  secret_string = aws_db_instance.main.address
}

resource "aws_secretsmanager_secret" "db_name" {
  name                    = "${var.environment}-db-name"
  description             = "Database name for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "db_name" {
  secret_id     = aws_secretsmanager_secret.db_name.id
  secret_string = var.db_name
}

resource "random_password" "jwt_secret" {
  length  = var.jwt_secret_length
  special = true
}

resource "aws_secretsmanager_secret" "jwt_secret" {
  name                    = "${var.environment}-jwt-secret"
  description             = "JWT secret for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 7

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "jwt_secret" {
  secret_id     = aws_secretsmanager_secret.jwt_secret.id
  secret_string = random_password.jwt_secret.result
}

resource "random_password" "openai_key" {
  length  = var.openai_key_length
  special = true
}

resource "aws_secretsmanager_secret" "openai_key" {
  name                    = "${var.environment}-openai-key"
  description             = "OpenAI API key for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 0

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "openai_key" {
  secret_id     = aws_secretsmanager_secret.openai_key.id
  secret_string = random_password.openai_key.result
}

resource "random_password" "slack_token" {
  length  = var.slack_token_length
  special = true
}

resource "aws_secretsmanager_secret" "slack_token" {
  name                    = "${var.environment}-slack-token"
  description             = "Slack token for AI platform"
  kms_key_id              = aws_kms_key.rds.key_id
  recovery_window_in_days = 0

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_secretsmanager_secret_version" "slack_token" {
  secret_id     = aws_secretsmanager_secret.slack_token.id
  secret_string = random_password.slack_token.result
}
