resource "aws_kms_key" "main" {
  description             = "KMS key for ${var.application_name} in ${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name               = "${var.environment}-${var.application_name}-kms-key"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.environment}/${var.application_name}"
  target_key_id = aws_kms_key.main.key_id
}
