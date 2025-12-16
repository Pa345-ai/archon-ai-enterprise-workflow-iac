data "archive_file" "empty_lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/empty_lambda.zip"
  source {
    content  = "exports.handler = (event, context, callback) => callback(null);"
    filename = "index.js"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db-subnet-group"
  })
}

resource "aws_db_instance" "main" {
  identifier           = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db"
  allocated_storage    = var.db_allocated_storage
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.db_security_group_id]
  backup_retention_period = 35
  multi_az             = true
  publicly_accessible  = false
  storage_encrypted    = true
  kms_key_id           = var.kms_key_id
  skip_final_snapshot  = false
  deletion_protection  = var.prevent_destroy
  manage_master_user_password = true
  master_user_secret_kms_key_id = var.kms_key_id

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db"
  })
}

resource "aws_iam_role" "secret_rotation" {
  name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secret-rotation-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "secret_rotation" {
  name   = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secret-rotation-policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
        ],
        Resource = aws_db_instance.main.master_user_secret[0].secret_arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetRandomPassword"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeNetworkInterfaces"
        ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "rds:DescribeDBInstances",
        Resource = aws_db_instance.main.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secret_rotation" {
  role       = aws_iam_role.secret_rotation.name
  policy_arn = aws_iam_policy.secret_rotation.arn
}

resource "aws_lambda_function" "secret_rotator" {
  # NOTE: This is a placeholder Lambda. The code for the rotator function
  # should be sourced from the official AWS Secrets Manager blueprints.
  # For deployment, the 'filename' should point to the ZIP file containing that code.
  filename         = data.archive_file.empty_lambda_zip.output_path
  function_name    = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secret-rotator"
  role             = aws_iam_role.secret_rotation.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.empty_lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.db_security_group_id]
  }

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.aws_region}.amazonaws.com"
    }
  }
}

resource "aws_secretsmanager_secret_rotation" "main" {
  secret_id           = aws_db_instance.main.master_user_secret[0].secret_arn
  rotation_lambda_arn = aws_lambda_function.secret_rotator.arn

  rotation_rules {
    automatically_after_days = 30
  }

  depends_on = [aws_lambda_function.secret_rotator]
}
