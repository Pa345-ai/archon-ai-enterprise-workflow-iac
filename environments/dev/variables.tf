variable "aws_region" {
  description = "The AWS region to deploy to."
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "The deployment environment."
  type        = string
  default     = "dev"
}

variable "application_name" {
  description = "The name of the application."
  type        = string
  default     = "ARCHON-AI"
}

variable "owner" {
  description = "The owner of the application."
  type        = string
  default     = "ArchonTeam"
}

variable "cost_center" {
  description = "The cost center for the application."
  type        = string
  default     = "IT-12345"
}

variable "data_classification" {
  description = "The data classification of the application."
  type        = string
  default     = "Confidential"
}

variable "db_name" {
  description = "The name of the database."
  type        = string
  default     = "archondb"
}

variable "alb_certificate_arn" {
  description = "The ARN of the ACM certificate for the ALB."
  type        = string
}

variable "backend_image_uri" {
  description = "The URI of the backend Docker image."
  type        = string
  default     = "nginx:1.21.6" # Placeholder
}

variable "alb_ingress_cidrs" {
  description = "The CIDR blocks to allow ingress from to the ALB."
  type        = list(string)
  default     = ["10.0.0.0/8"] # Default to internal network
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_allocated_storage" {
  description = "The allocated storage for the database in GB."
  type        = number
  default     = 20
}

variable "db_instance_class" {
  description = "The instance class for the database."
  type        = string
  default     = "db.t3.micro"
}

variable "fargate_cpu" {
  description = "The amount of CPU to allocate to the Fargate tasks."
  type        = number
  default     = 1024
}

variable "fargate_memory" {
  description = "The amount of memory to allocate to the Fargate tasks."
  type        = number
  default     = 2048
}
