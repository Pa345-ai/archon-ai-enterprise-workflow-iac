# Monitoring Module - outputs.tf

output "log_group_name" {
  description = "The name of the Fargate log group."
  value       = aws_cloudwatch_log_group.fargate_logs.name
}
