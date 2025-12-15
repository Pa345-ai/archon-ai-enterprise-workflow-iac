resource "aws_security_group" "alb" {
  name   = "${var.environment}-${var.application_name}-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-alb-sg"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_security_group" "ecs" {
  name   = "${var.environment}-${var.application_name}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.db.id]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-ecs-sg"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_security_group" "db" {
  name   = "${var.environment}-${var.application_name}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-db-sg"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_security_group" "secretsmanager_endpoint" {
  name   = "${var.environment}-${var.application_name}-secretsmanager-endpoint-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-secretsmanager-endpoint-sg"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
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

  tags = {
    Name               = "${var.environment}-${var.application_name}-secretsmanager-endpoint"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}
