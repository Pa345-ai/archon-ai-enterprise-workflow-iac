
# Defines all crucial outputs needed by the CBA team for integration and testing
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer for the frontend access."
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  description = "The name of the deployed ECS cluster."
  value       = aws_ecs_cluster.main.name
}
