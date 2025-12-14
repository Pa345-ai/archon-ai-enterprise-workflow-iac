# ECS Service Module - variables.tf

variable "environment" {
  description = "The deployment environment."
  type        = string
}

variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "owner" {
  description = "The owner of the resources."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the resources."
  type        = string
}

variable "aws_region" {
  description = "The AWS region."
  type        = string
}

variable "fargate_cpu" {
  description = "The CPU for the Fargate tasks."
  type        = number
}

variable "fargate_memory" {
  description = "The memory for the Fargate tasks."
  type        = number
}

variable "backend_image_uri" {
  description = "The URI of the backend Docker image."
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch log group."
  type        = string
}

variable "db_user_secret_arn" {
  description = "The ARN of the DB user secret."
  type        = string
}

variable "db_password_secret_arn" {
  description = "The ARN of the DB password secret."
  type        = string
}

variable "db_host_secret_arn" {
  description = "The ARN of the DB host secret."
  type        = string
}

variable "db_name_secret_arn" {
  description = "The ARN of the DB name secret."
  type        = string
}

variable "jwt_secret_arn" {
  description = "The ARN of the JWT secret."
  type        = string
}

variable "openai_key_secret_arn" {
  description = "The ARN of the OpenAI key secret."
  type        = string
}

variable "slack_token_secret_arn" {
  description = "The ARN of the Slack token secret."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "The ID of the ECS security group."
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "alb_certificate_arn" {
  description = "The ARN of the ALB certificate."
  type        = string
}
