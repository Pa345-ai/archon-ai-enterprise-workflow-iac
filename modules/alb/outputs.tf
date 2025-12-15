output "alb_arn" {
  description = "The ARN of the ALB."
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.main.dns_name
}

output "main_target_group_arn" {
  description = "The ARN of the main target group."
  value       = aws_lb_target_group.main.arn
}

output "integrations_target_group_arn" {
  description = "The ARN of the integrations target group."
  value       = aws_lb_target_group.integrations.arn
}
