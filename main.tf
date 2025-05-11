module "iam_role" {
  source                 = "./modules/iam_roles"
  aws_prefect_worker_arm = var.secret_arn
}

module "aws_vpc" {
  source   = "./modules/vpc"
  vpc_name = "prefect-ecs"
}

module "ecs_cluster" {
  source           = "./modules/ecs_cluster"
  ecs_cluster_name = var.ecs_cluster_name
  vpc_id           = module.aws_vpc.vpc_id
}


module "ecs_tasks" {
  source                  = "./modules/ecs_tasks"
  secret_arn              = var.secret_arn
  prefect_api_url         = var.prefect_api_url
  prefect_workspace_id    = var.prefect_workspace_id
  prefect_account_id      = var.prefect_account_id
  aws_task_execution_role = module.iam_role.aws_task_execution_role
}

module "ecs_service" {
  source                 = "./modules/ecs_service"
  ecs_service_name       = var.ecs_service_name
  aws_ecs_cluster_id     = module.ecs_cluster.ecs_cluster_id
  aws_prefect_worker_arm = module.ecs_tasks.prefect_worker_arn
  subnet_ids             = module.aws_vpc.private_subnet_ids
  security_group_id      = module.security_groups.ecs_service_sg_id
}

module "security_groups" {
  source         = "./modules/security_groups"
  vpc_id         = module.aws_vpc.vpc_id
  vpc_cidr_block = module.aws_vpc.vpc_cidr_block
}




