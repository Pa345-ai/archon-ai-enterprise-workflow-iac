resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-${var.application_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name               = "${var.environment}-${var.application_name}-ecs-execution-role"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_core_role" {
  name = "${var.environment}-${var.application_name}-ecs-task-core-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name               = "${var.environment}-${var.application_name}-ecs-task-core-role"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_iam_policy" "ecs_task_core_secrets" {
  name = "${var.environment}-${var.application_name}-ecs-task-core-secrets"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue",
        Effect   = "Allow",
        Resource = var.core_task_secrets
      },
      {
        Action   = "kms:Decrypt",
        Effect   = "Allow",
        Resource = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_core_secrets" {
  role       = aws_iam_role.ecs_task_core_role.name
  policy_arn = aws_iam_policy.ecs_task_core_secrets.arn
}

resource "aws_iam_role" "ecs_task_integrations_role" {
  name = "${var.environment}-${var.application_name}-ecs-task-integrations-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name               = "${var.environment}-${var.application_name}-ecs-task-integrations-role"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_iam_policy" "ecs_task_integrations_secrets" {
  name = "${var.environment}-${var.application_name}-ecs-task-integrations-secrets"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue",
        Effect   = "Allow",
        Resource = var.integrations_task_secrets
      },
      {
        Action   = "kms:Decrypt",
        Effect   = "Allow",
        Resource = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_integrations_secrets" {
  role       = aws_iam_role.ecs_task_integrations_role.name
  policy_arn = aws_iam_policy.ecs_task_integrations_secrets.arn
}
