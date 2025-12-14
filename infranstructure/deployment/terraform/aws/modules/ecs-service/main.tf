# ECS Service Module - main.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name        = "${var.environment}-ecs-cluster"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_ecs_task_definition" "backend_core" {
  family                   = "backend-core-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_core_role.arn
  container_definitions = jsonencode([
    {
      name  = "backend-core"
      image = var.backend_image_uri
      portMappings = [{
        containerPort = 8000
        hostPort      = 8000
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "backend-core"
        }
      }
      secrets = [
        { name = "DB_USER", valueFrom = var.db_user_secret_arn },
        { name = "DB_PASSWORD", valueFrom = var.db_password_secret_arn },
        { name = "DB_HOST", valueFrom = var.db_host_secret_arn },
        { name = "DB_NAME", valueFrom = var.db_name_secret_arn },
        { name = "JWT_SECRET", valueFrom = var.jwt_secret_arn }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_core" {
  name            = "backend-core-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_core.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "backend-core"
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "backend_integrations" {
  family                   = "backend-integrations-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_integrations_role.arn
  container_definitions = jsonencode([
    {
      name  = "backend-integrations"
      image = var.backend_image_uri
      portMappings = [{
        containerPort = 8000
        hostPort      = 8000
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "backend-integrations"
        }
      }
      secrets = [
        { name = "OPENAI_API_KEY", valueFrom = var.openai_key_secret_arn },
        { name = "SLACK_TOKEN", valueFrom = var.slack_token_secret_arn }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_integrations" {
  name            = "backend-integrations-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_integrations.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.integrations.arn
    container_name   = "backend-integrations"
    container_port   = 8000
  }
}

resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = true

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.environment}-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.environment}-tg"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_lb_target_group" "integrations" {
  name        = "${var.environment}-integrations-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    Name        = "${var.environment}-integrations-tg"
    Environment = var.environment
    Application = var.application_name
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.alb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener_rule" "integrations" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.integrations.arn
  }

  condition {
    path_pattern {
      values = ["/integrations/*"]
    }
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
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
}

resource "aws_iam_role_policy" "ecs_task_core_secrets" {
  name = "${var.environment}-${var.application_name}-ecs-task-core-secrets"
  role = aws_iam_role.ecs_task_core_role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action   = "secretsmanager:GetSecretValue",
      Effect   = "Allow",
      Resource = [
        var.db_user_secret_arn,
        var.db_password_secret_arn,
        var.db_host_secret_arn,
        var.db_name_secret_arn,
        var.jwt_secret_arn
      ]
    }]
  })
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
}

resource "aws_iam_role_policy" "ecs_task_integrations_secrets" {
  name = "${var.environment}-${var.application_name}-ecs-task-integrations-secrets"
  role = aws_iam_role.ecs_task_integrations_role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action   = "secretsmanager:GetSecretValue",
      Effect   = "Allow",
      Resource = [
        var.openai_key_secret_arn,
        var.slack_token_secret_arn
      ]
    }]
  })
}
