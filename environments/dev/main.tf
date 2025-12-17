provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.common_tags,
    {
      Environment        = var.environment
      Application        = var.application_name
      Owner             = var.owner
      CostCenter        = var.cost_center
      DataClassification = var.data_classification
      ManagedBy         = "Terraform"
      Version           = "1.0.0"
    }
  )
}

module "kms" {
  source      = "../../modules/kms"
  common_tags = local.common_tags
}

module "vpc" {
  source               = "../../modules/vpc"
  aws_region           = var.aws_region
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  common_tags          = local.common_tags
}

module "security" {
  source                = "../../modules/security"
  vpc_id                = module.vpc.vpc_id
  aws_region            = var.aws_region
  private_subnet_ids    = module.vpc.private_subnet_ids
  allowed_ingress_cidrs = var.alb_ingress_cidrs
  common_tags           = local.common_tags
}

module "logging" {
  source      = "../../modules/logging"
  vpc_id      = module.vpc.vpc_id
  kms_key_arn = module.kms.kms_key_arn
  common_tags = local.common_tags
}

module "rds" {
  source                 = "../../modules/rds"
  private_subnet_ids     = module.vpc.private_subnet_ids
  db_security_group_id   = module.security.db_security_group_id
  kms_key_id             = module.kms.kms_key_id
  db_allocated_storage   = 20
  db_instance_class      = "db.t3.micro"
  db_name                = var.db_name
  aws_region             = var.aws_region
  common_tags            = local.common_tags
}

module "secrets" {
  source      = "../../modules/secrets"
  kms_key_id  = module.kms.kms_key_id
  common_tags = local.common_tags
}

module "iam" {
  source                    = "../../modules/iam"
  kms_key_arn               = module.kms.kms_key_arn
  core_task_secrets         = [module.rds.master_user_secret_arn]
  integrations_task_secrets = values(module.secrets.secret_arns)
  common_tags               = local.common_tags
}

module "alb" {
  source                  = "../../modules/alb"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  alb_security_group_id   = module.security.alb_security_group_id
  alb_certificate_arn     = var.alb_certificate_arn
  access_logs_bucket_name = module.logging.access_logs_bucket_name
  common_tags             = local.common_tags
}

module "ecs" {
  source                        = "../../modules/ecs"
  aws_region                    = var.aws_region
  private_subnet_ids            = module.vpc.private_subnet_ids
  ecs_security_group_id         = module.security.ecs_security_group_id
  ecs_execution_role_arn        = module.iam.ecs_execution_role_arn
  core_task_role_arn            = module.iam.ecs_task_core_role_arn
  integrations_task_role_arn    = module.iam.ecs_task_integrations_role_arn
  backend_image_uri             = var.backend_image_uri
  fargate_cpu                   = 1024
  fargate_memory                = 2048
  main_target_group_arn         = module.alb.main_target_group_arn
  integrations_target_group_arn = module.alb.integrations_target_group_arn
  log_group_name                = module.logging.ecs_log_group_name
  common_tags                   = local.common_tags

  core_task_secrets = {
    DB_CONNECTION_STRING = module.rds.master_user_secret_arn
  }
  integrations_task_secrets = {
    for k, v in module.secrets.secret_arns : upper(k) => v
  }
}

module "waf" {
  source      = "../../modules/waf"
  alb_arn     = module.alb.alb_arn
  common_tags = local.common_tags
}
