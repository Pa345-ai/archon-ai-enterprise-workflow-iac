resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu  # Updated to use variable
  memory                   = var.fargate_memory  # Updated to use variable
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn  # Assume defined elsewhere

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = var.backend_image_uri  # e.g., from ECR
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      secrets = [
        {
          name      = "DB_USER"
          valueFrom = aws_secretsmanager_secret.db_user.arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = aws_secretsmanager_secret.db_password.arn
        },
        {
          name      = "DB_HOST"
          valueFrom = aws_secretsmanager_secret.db_host.arn
        },
        {
          name      = "DB_NAME"
          valueFrom = aws_secretsmanager_secret.db_name.arn
        },
        {
          name      = "JWT_SECRET"
          valueFrom = aws_secretsmanager_secret.jwt_secret.arn
        },
        {
          name      = "OPENAI_API_KEY"
          valueFrom = aws_secretsmanager_secret.openai_key.arn
        },
        {
          name      = "SLACK_TOKEN"
          valueFrom = aws_secretsmanager_secret.slack_token.arn
        }
      ]
    }
  ])
}

# ECS Service (updated desired_count to 2 for HA)
resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2  # Changed for High Availability
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = aws_subnet.private[*].id
    security_groups = [aws_security_group.ecs.id]  # Define SG
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 8000
  }
}
