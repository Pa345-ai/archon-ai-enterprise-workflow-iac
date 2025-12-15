data "aws_secretsmanager_secret" "core" {
  for_each = toset(var.core_task_secret_names)
  name     = "${var.environment}-${var.application_name}-${each.key}"
}

data "aws_secretsmanager_secret" "integrations" {
  for_each = toset(var.integrations_task_secret_names)
  name     = "${var.environment}-${var.application_name}-${each.key}"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-${var.application_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-ecs-cluster"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_ecs_task_definition" "backend_core" {
  family                   = "${var.environment}-${var.application_name}-backend-core-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.core_task_role_arn

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
        for name, secret in data.aws_secretsmanager_secret.core : {
          name      = name
          valueFrom = secret.arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_core" {
  name            = "${var.environment}-${var.application_name}-backend-core-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_core.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = var.main_target_group_arn
    container_name   = "backend-core"
    container_port   = 8000
  }
}

resource "aws_appautoscaling_target" "ecs_core_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.backend_core.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_core_cpu" {
  name               = "${var.environment}-${var.application_name}-ecs-core-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_core_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_core_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_core_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75
  }
}

resource "aws_ecs_task_definition" "backend_integrations" {
  family                   = "${var.environment}-${var.application_name}-backend-integrations-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.integrations_task_role_arn

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
        for name, secret in data.aws_secretsmanager_secret.integrations : {
          name      = name
          valueFrom = secret.arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_integrations" {
  name            = "${var.environment}-${var.application_name}-backend-integrations-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_integrations.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = var.integrations_target_group_arn
    container_name   = "backend-integrations"
    container_port   = 8000
  }
}

resource "aws_appautoscaling_target" "ecs_integrations_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.backend_integrations.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_integrations_cpu" {
  name               = "${var.environment}-${var.application_name}-ecs-integrations-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_integrations_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_integrations_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_integrations_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75
  }
}
