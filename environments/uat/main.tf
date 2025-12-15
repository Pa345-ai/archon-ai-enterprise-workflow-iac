provider "aws" {
  region = var.aws_region
}

module "kms" {
  source = "../../modules/kms"

  environment        = var.environment
  application_name     = var.application_name
  owner              = var.owner
  cost_center        = var.cost_center
  data_classification = var.data_classification
}

module "vpc" {
  source = "../../modules/vpc"

  aws_region           = var.aws_region
  environment          = var.environment
  application_name     = var.application_name
  owner                = var.owner
  cost_center          = var.cost_center
  data_classification  = var.data_classification
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.101.0/24", "10.1.102.0/24"]
}

module "security" {
  source = "../../modules/security"

  environment          = var.environment
  application_name     = var.application_name
  owner                = var.owner
  cost_center          = var.cost_center
  data_classification  = var.data_classification
  vpc_id               = module.vpc.vpc_id
  aws_region           = var.aws_region
  private_subnet_ids   = module.vpc.private_subnet_ids
  allowed_ingress_cidrs = ["0.0.0.0/0"] # UAT should be restricted
}

module "logging" {
  source = "../../modules/logging"

  environment        = var.environment
  application_name     = var.application_name
  owner              = var.owner
  cost_center        = var.cost_center
  data_classification = var.data_classification
  vpc_id               = module.vpc.vpc_id
  kms_key_arn          = module.kms.kms_key_arn
}

module "rds" {
  source = "../../modules/rds"

  environment           = var.environment
  application_name      = var.application_name
  owner                 = var.owner
  cost_center           = var.cost_center
  data_classification   = var.data_classification
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_security_group_id  = module.security.db_security_group_id
  kms_key_id            = module.kms.kms_key_id
  db_allocated_storage  = 100
  db_instance_class     = "db.t3.small"
  db_name               = var.db_name
  db_username           = "dummyuser" # Placeholder
}

module "secrets" {
  source = "../../modules/secrets"

  environment           = var.environment
  application_name      = var.application_name
  owner                 = var.owner
  cost_center           = var.cost_center
  data_classification   = var.data_classification
  kms_key_id            = module.kms.kms_key_id
}

module "iam" {
  source = "../../modules/iam"

  environment                = var.environment
  application_name           = var.application_name
  owner                      = var.owner
  cost_center                = var.cost_center
  data_classification        = var.data_classification
  kms_key_arn                = module.kms.kms_key_arn
  core_task_secrets          = [module.rds.master_user_secret_arn]
  integrations_task_secrets  = values(module.secrets.secret_arns)
}

module "alb" {
  source = "../../modules/alb"

  environment           = var.environment
  application_name      = var.application_name
  owner                 = var.owner
  cost_center           = var.cost_center
  data_classification   = var.data_classification
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  alb_certificate_arn   = var.alb_certificate_arn
  access_logs_bucket_name = module.logging.access_logs_bucket_name
}

module "ecs" {
  source = "../../modules/ecs"

  environment                 = var.environment
  application_name            = var.application_name
  owner                       = var.owner
  cost_center                 = var.cost_center
  data_classification         = var.data_classification
  aws_region                  = var.aws_region
  private_subnet_ids          = module.vpc.private_subnet_ids
  ecs_security_group_id       = module.security.ecs_security_group_id
  ecs_execution_role_arn      = module.iam.ecs_execution_role_arn
  core_task_role_arn          = module.iam.ecs_task_core_role_arn
  integrations_task_role_arn  = module.iam.ecs_task_integrations_role_arn
  core_task_secret_names      = [module.rds.master_user_secret_arn]
  integrations_task_secret_names = values(module.secrets.secret_arns)
  backend_image_uri           = var.backend_image_uri
  fargate_cpu                 = 2048
  fargate_memory              = 4096
  main_target_group_arn       = module.alb.main_target_group_arn
  integrations_target_group_arn = module.alb.integrations_target_group_arn
  log_group_name              = module.logging.ecs_log_group_name
}

module "waf" {
  source = "../../modules/waf"

  environment        = var.environment
  application_name     = var.application_name
  owner              = var.owner
  cost_center        = var.cost_center
  data_classification = var.data_classification
  alb_arn              = module.alb.alb_arn
}
