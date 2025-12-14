# Root - main.tf

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = "10.0.0.0/16" # Example value
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # Example values
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # Example values
  environment          = var.environment
  application_name     = var.application_name
  owner                = var.owner
  cost_center          = var.cost_center
  aws_region           = var.aws_region
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

# NOTE: Policy-as-Code checks for mandatory tagging and ingress rules
# should be implemented here using a dedicated tool like Sentinel or OPA.
# The current implementation uses variable validation as a partial solution.

module "database" {
  source = "./modules/database"

  environment                  = var.environment
  application_name             = var.application_name
  owner                        = var.owner
  cost_center                  = var.cost_center
  private_subnet_ids           = module.vpc.private_subnet_ids
  db_allocated_storage         = 20 # Example value
  db_instance_class            = "db.t3.micro" # Example value
  db_name                      = "archondb" # Example value
  db_security_group_id         = module.vpc.db_security_group_id
  db_backup_retention_period   = 7 # Example value
  db_password_length           = 16 # Example value
  jwt_secret_length            = 32 # Example value
  openai_key_length            = 48 # Example value
  slack_token_length           = 32 # Example value
}

module "monitoring" {
  source = "./modules/monitoring"

  environment      = var.environment
  application_name = var.application_name
  owner            = var.owner
  cost_center      = var.cost_center
  vpc_id           = module.vpc.vpc_id
}

module "ecs-service" {
  source = "./modules/ecs-service"

  environment              = var.environment
  application_name         = var.application_name
  owner                    = var.owner
  cost_center              = var.cost_center
  aws_region               = var.aws_region
  fargate_cpu              = var.fargate_cpu
  fargate_memory           = var.fargate_memory
  backend_image_uri        = var.backend_image_uri
  log_group_name           = module.monitoring.log_group_name
  db_user_secret_arn       = module.database.db_user_secret_arn
  db_password_secret_arn   = module.database.db_password_secret_arn
  db_host_secret_arn       = module.database.db_host_secret_arn
  db_name_secret_arn       = module.database.db_name_secret_arn
  jwt_secret_arn           = module.database.jwt_secret_arn
  openai_key_secret_arn    = module.database.openai_key_secret_arn
  slack_token_secret_arn   = module.database.slack_token_secret_arn
  private_subnet_ids       = module.vpc.private_subnet_ids
  public_subnet_ids        = module.vpc.public_subnet_ids
  ecs_security_group_id    = module.vpc.ecs_security_group_id
  alb_security_group_id    = module.vpc.alb_security_group_id
  vpc_id                   = module.vpc.vpc_id
  alb_certificate_arn      = var.alb_certificate_arn
}
