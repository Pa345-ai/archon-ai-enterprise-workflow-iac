resource "aws_security_group" "alb" {
  name        = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-alb-sg"
  description = "Controls access to the Application Load Balancer."
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the internet."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  ingress {
    description = "Allow HTTPS traffic from the internet."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-alb-sg"
  })
}

resource "aws_security_group" "ecs" {
  name        = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-sg"
  description = "Controls access to the ECS tasks."
  vpc_id      = var.vpc_id


  egress {
    description = "Allow outbound traffic to the internet."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-ecs-sg"
  })
}

resource "aws_security_group" "db" {
  name        = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db-sg"
  description = "Controls access to the RDS database."
  vpc_id      = var.vpc_id


  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-db-sg"
  })
}

resource "aws_security_group_rule" "ecs_ingress_from_alb" {
  type                     = "ingress"
  description              = "Allow traffic from the ALB to the ECS tasks."
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "ecs_egress_to_db" {
  type                     = "egress"
  description              = "Allow traffic from the ECS tasks to the RDS database."
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
  security_group_id        = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "db_ingress_from_ecs" {
  type                     = "ingress"
  description              = "Allow traffic from the ECS tasks to the RDS database."
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs.id
  security_group_id        = aws_security_group.db.id
}

resource "aws_security_group" "secretsmanager_endpoint" {
  name        = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secretsmanager-endpoint-sg"
  description = "Controls access to the Secrets Manager VPC endpoint."
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from the ECS tasks to the Secrets Manager VPC endpoint."
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secretsmanager-endpoint-sg"
  })
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids

  security_group_ids = [
    aws_security_group.secretsmanager_endpoint.id,
  ]

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-secretsmanager-endpoint"
  })
}
