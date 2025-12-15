variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "owner" {
  description = "The owner of the application."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the application."
  type        = string
}

variable "data_classification" {
  description = "The data classification of the application."
  type        = string
}

variable "aws_region" {
  description = "The AWS region."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the ECS security group."
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role."
  type        = string
}

variable "core_task_role_arn" {
  description = "The ARN of the core task role."
  type        = string
}

variable "integrations_task_role_arn" {
  description = "The ARN of the integrations task role."
  type        = string
}

variable "backend_image_uri" {
  description = "The URI of the backend Docker image."
  type        = string
}

variable "fargate_cpu" {
  description = "The amount of CPU to allocate to the Fargate tasks."
  type        = number
}

variable "fargate_memory" {
  description = "The amount of memory to allocate to the Fargate tasks."
  type        = number
}

variable "main_target_group_arn" {
  description = "The ARN of the main target group."
  type        = string
}

variable "integrations_target_group_arn" {
  description = "The ARN of the integrations target group."
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
}

variable "core_task_secret_names" {
  description = "A list of secret names for the core task to access."
  type        = list(string)
}

variable "integrations_task_secret_names" {
  description = "A list of secret names for the integrations task to access."
  type        = list(string)
}
