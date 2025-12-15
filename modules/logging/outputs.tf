output "ecs_log_group_name" {
  description = "The name of the ECS CloudWatch log group."
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "access_logs_bucket_name" {
  description = "The name of the S3 bucket for ALB access logs."
  value       = aws_s3_bucket.access_logs.bucket
}
