variable "common_tags" {
  description = "A map of key-value pairs to apply as tags to all created RDS resources. This is essential for cost allocation, automation, and auditing."
  type        = map(string)
  default     = {}
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs where the RDS instance will be deployed. These must be valid subnet IDs within the target VPC."
  type        = list(string)
}

variable "db_security_group_id" {
  description = "The ID of the security group to associate with the RDS instance. This security group should control inbound traffic to the database."
  type        = string
}

variable "kms_key_id" {
  description = "The ID of the KMS key used to encrypt the RDS instance and the master user secret. This must be a valid KMS key ID."
  type        = string
}

variable "db_allocated_storage" {
  description = "The amount of storage to allocate to the database, in gigabytes. For production workloads, this should be sized appropriately for the expected data volume."
  type        = number

  validation {
    condition     = var.db_allocated_storage >= 20
    error_message = "The db_allocated_storage must be at least 20 GB."
  }
}

variable "db_instance_class" {
  description = "The instance class for the RDS database (e.g., 'db.t3.micro', 'db.m5.large'). The choice of instance class will determine the CPU, memory, and network performance of the database."
  type        = string
}

variable "db_name" {
  description = "The name of the initial database to be created within the RDS instance. This name should be descriptive of the application's purpose."
  type        = string
}

variable "enable_deletion_protection" {
  description = "A boolean flag that, when set to true, enables deletion protection on the RDS instance. This is a critical safety feature for production environments."
  type        = bool
  default     = false
}

variable "aws_region" {
  description = "The AWS region where resources are deployed. This is required for the Secrets Manager endpoint in the rotation Lambda's environment variables."
  type        = string
}
