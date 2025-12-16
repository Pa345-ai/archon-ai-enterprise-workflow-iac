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
