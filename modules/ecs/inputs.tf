variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created ECS resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region where the ECS cluster and services are deployed. This is required for the CloudWatch Logs configuration."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the ECS tasks will be launched. These subnets must have a route to a NAT Gateway to pull container images."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the security group to associate with the ECS tasks. This security group should control traffic to and from the containers."
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the IAM role that the ECS agent uses to make API calls on your behalf (e.g., pulling container images from ECR)."
  type        = string
}

variable "core_task_role_arn" {
  description = "The ARN of the IAM role that grants permissions to the containers in the 'core' ECS task. This role should have access to the necessary secrets."
  type        = string
}

variable "integrations_task_role_arn" {
  description = "The ARN of the IAM role that grants permissions to the containers in the 'integrations' ECS task. This role should have access to the necessary secrets."
  type        = string
}

variable "backend_image_uri" {
  description = "The URI of the Docker image to be deployed for the backend services. This should be a valid ECR image URI (e.g., '123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest')."
  type        = string
}

variable "fargate_cpu" {
  description = "The number of CPU units to reserve for each Fargate task. This must be a valid Fargate CPU value (e.g., 256, 512, 1024)."
  type        = number
}

variable "fargate_memory" {
  description = "The amount of memory (in MiB) to reserve for each Fargate task. This must be a valid Fargate memory value."
  type        = number
}

variable "main_target_group_arn" {
  description = "The ARN of the ALB target group to which the 'core' ECS service will register its tasks."
  type        = string
}

variable "integrations_target_group_arn" {
  description = "The ARN of the ALB target group to which the 'integrations' ECS service will register its tasks."
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch Log Group where the container logs will be sent."
  type        = string
}

variable "core_task_secret_names" {
  description = "A list of secret names that the 'core' ECS task needs to access. The module will look up the ARNs of these secrets."
  type        = list(string)
}

variable "integrations_task_secret_names" {
  description = "A list of secret names that the 'integrations' ECS task needs to access. The module will look up the ARNs of these secrets."
  type        = list(string)
}
