module "ecs_cluster" {
  source            = "./modules/ecs/ecs-cluster"
  containerInsights = "disabled"
  tags              = local.tags
}

module "ecs_security_group" {
  source                   = "./modules/ecs/ecs-security-group"
  source_security_group_id = module.ecs_loadbalancer.security_group_id
  port                     = 3000
  tags                     = local.tags
}

module "ecs_loadbalancer" {
  source                         = "./modules/ecs/ecs-alb"
  listener_rule_condition_values = aws_route53_record.api_endpoint.name
  target_group_port              = 3000
  tags                           = local.tags
}

# Before any Terraform apply you will need to check the ignored changes in ecs service and codedeploy
module "ecs_service" {
  source                                         = "./modules/ecs/ecs-service"
  ecs_cluster_name                               = module.ecs_cluster.aws_ecs_cluster_name
  ecs_cluster_id                                 = module.ecs_cluster.aws_ecs_cluster_id
  attach_service_discovery                       = false
  aws_service_discovery_private_dns_namespace_id = local.aws_service_discovery_private_dns_namespace_id
  ecs_security_group_id                          = module.ecs_security_group.aws_security_group_id
  aws_lb_listener_https_arn                      = module.ecs_loadbalancer.listener_https_arn
  aws_lb_target_group_arn                        = module.ecs_loadbalancer.aws_lb_target_group_arn
  platform_version                               = "1.4.0"
  ecs_parameters                                 = var.ecs_parameters[local.envtype]
  tags                                           = local.tags
}

module "ecs_deploy" {
  source                         = "./modules/ecs/ecs-deploy"
  aws_account_id                 = local.aws_account_id
  deployer_role                  = local.deployer_role
  ecs_cluster_name               = module.ecs_cluster.aws_ecs_cluster_name
  ecs_service_name               = module.ecs_service.ecs_service_name
  lb_listener_arn                = module.ecs_loadbalancer.listener_https_arn
  blue_lb_target_group_name      = module.ecs_loadbalancer.aws_lb_target_group_name
  listener_rule_condition_values = aws_route53_record.api_endpoint.name
  action_on_timeout              = var.ecs_parameters[local.envtype].action_on_timeout
  tags                           = local.tags

  depends_on = [module.ecs_loadbalancer]
}

module "ecs_alarms" {
  source       = "./modules/ecs/ecs-alarms"
  cw_alarms    = local.envtype == "production" ? true : false
  cluster_name = module.ecs_cluster.aws_ecs_cluster_name
  service_name = module.ecs_service.ecs_service_name
  depends_on   = [ module.ecs_service, module.ecs_cluster, module.ecs_loadbalancer ]
  tags         = local.tags
}
