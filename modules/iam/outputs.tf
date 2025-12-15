output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_core_role_arn" {
  description = "The ARN of the ECS task core role."
  value       = aws_iam_role.ecs_task_core_role.arn
}

output "ecs_task_integrations_role_arn" {
  description = "The ARN of the ECS task integrations role."
  value       = aws_iam_role.ecs_task_integrations_role.arn
}
