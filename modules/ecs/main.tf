resource "aws_ecs_cluster" "main" {
  name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-cluster"
  })
}

resource "aws_ecs_task_definition" "backend_core" {
  family                   = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-backend-core-task"
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
        for name, arn in var.core_task_secrets : {
          name      = name
          valueFrom = arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_core" {
  name            = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-backend-core-service"
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
  name               = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-core-cpu-scaling"
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
  family                   = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-backend-integrations-task"
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
        for name, arn in var.integrations_task_secrets : {
          name      = name
          valueFrom = arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "backend_integrations" {
  name            = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-backend-integrations-service"
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
  name               = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-integrations-cpu-scaling"
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
