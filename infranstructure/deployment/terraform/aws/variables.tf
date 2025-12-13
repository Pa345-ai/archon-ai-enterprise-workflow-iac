# Defines all variables that the CBA team may need to easily change for integration or scale
variable "aws_region" {
  description = "The AWS region to deploy the ARCHON AI platform into."
  type        = string
  default     = "ap-southeast-2" # Sydney region, appropriate for CBA
}

variable "backend_image_uri" {
  description = "The URI for the backend (FastAPI/Python) Docker image in ECR."
  type        = string
  # CBA engineers will update this with their ECR path
  default     = "123456789012.dkr.ecr.ap-southeast-2.amazonaws.com/archon-ai-backend:latest"
}

variable "fargate_cpu" {
  description = "Fargate task CPU capacity (e.g., 256, 512, 1024)."
  type        = number
  default     = 1024 # Enterprise default: 1 vCPU
}

variable "fargate_memory" {
  description = "Fargate task memory (e.g., 512, 1024, 2048)."
  type        = number
  default     = 2048 # Enterprise default: 2 GB
}

variable "alb_certificate_arn" {
  description = "The ARN of a valid AWS Certificate Manager (ACM) certificate for the ALB (e.g., for example.cba.com.au)."
  type        = string
}
