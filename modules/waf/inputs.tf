variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to the WAF Web ACL. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "alb_arn" {
  description = "The ARN of the Application Load Balancer to be protected by this WAF Web ACL. This must be a valid ALB ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:[a-z0-9-]+:[0-9]{12}:loadbalancer/app/.*$", var.alb_arn))
    error_message = "The alb_arn must be a valid Application Load Balancer ARN."
  }
}
