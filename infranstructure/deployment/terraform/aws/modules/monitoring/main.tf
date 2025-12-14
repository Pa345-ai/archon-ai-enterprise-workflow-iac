# Monitoring Module - main.tf

resource "aws_cloudwatch_log_group" "fargate_logs" {
  name              = "/ecs/fargate-services"
  retention_in_days = 365

  tags = {
    Name        = "fargate-service-logs"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/${var.environment}-ai-platform"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "${var.environment}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_policy" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCFlowLogsRole"
}
