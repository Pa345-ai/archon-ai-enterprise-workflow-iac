output "alb_security_group_id" {
  description = "The ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "The ID of the ECS security group."
  value       = aws_security_group.ecs.id
}

output "db_security_group_id" {
  description = "The ID of the RDS security group."
  value       = aws_security_group.db.id
}
