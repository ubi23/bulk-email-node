module "codebuild_db_migration" {
  source                  = "./modules/migration-db-one-off-task/"
  aws_account_id          = local.aws_account_id
  deployer_role           = local.deployer_role
  task_execution_role     = module.ecs_service.task_execution_role_arn
  task_role               = module.ecs_service.task_role_arn
  ecs_log_group_name      = module.ecs_service.ecs_log_group_name
  ecs_cluster_name        = module.ecs_cluster.aws_ecs_cluster_name
  task_definition_command = ["npm", "run", "db:migrate"]

  vpc_id            = data.aws_vpc.main.id
  subnet_ids        = data.aws_subnet.private
  security_group_id = module.ecs_security_group.aws_security_group_id
  depends_on        = [module.ecs_service]
  tags              = module.common.tags
}
