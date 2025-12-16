resource "aws_kms_key" "main" {
  count = var.existing_kms_key_arn == null ? 1 : 0

  description             = "KMS key for ${var.common_tags["Application"]} in ${var.common_tags["Environment"]}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["Environment"]}-${var.common_tags["Application"]}-kms-key"
  })
}

resource "aws_kms_alias" "main" {
  count = var.existing_kms_key_arn == null ? 1 : 0

  name          = "alias/${var.common_tags["Environment"]}/${var.common_tags["Application"]}"
  target_key_id = aws_kms_key.main[0].key_id
}
