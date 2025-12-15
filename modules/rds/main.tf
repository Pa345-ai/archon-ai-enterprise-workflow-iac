resource "aws_db_subnet_group" "default" {
  name       = "${var.environment}-${var.application_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name               = "${var.environment}-${var.application_name}-db-subnet-group"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-${var.application_name}-db"
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

  tags = {
    Name               = "${var.environment}-${var.application_name}-db"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}
