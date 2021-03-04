module "common" {
  source      = "git@github.com:EqualsGroup/terraform-common.git?ref=v1.2.x"
  service     = "bulk-email"
  environment = local.environment
  project     = "EqualsGroup/bulk-email-node"
}

locals {
  account_name       = terraform.workspace
  account            = module.aws_accounts.meta.accounts[local.account_name]
  environment        = local.account.org_name
  aws_account_id     = local.account.id
  resource_name      = module.common.resource_name
  dns_aws_account_id = module.aws_accounts.meta.accounts.dns-shared.id
  provisioner_role   = "${module.common.tags.Organisation}@${module.common.tags.Service}@provisioner"
  deployer_role      = "${module.common.tags.Organisation}@${module.common.tags.Service}@deployer"

  api_endpoint = "bulk-email.${var.ecs_parameters[local.environment].domain}"

  aws_service_discovery_private_dns_namespace_id = split("/", data.aws_route53_zone.service_discovery_namespace.linked_service_description)[1]
  tags                                           = merge(module.common.tags, { "AccountName" : local.account_name })
}

variable "ecs_parameters" {
  type = map(map(string))
  default = {
    "shared" = {
      max_tasks                    = "5"
      min_tasks                    = "1"
      autoscaling_cpu_threshold    = "85"
      autoscaling_memory_threshold = "85"
      desired_count                = "1"
      action_on_timeout            = "CONTINUE_DEPLOYMENT"
      domain                       = "equals.io"
      service_discovery_domain     = "shared."
    }
  }
}
