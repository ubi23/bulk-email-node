module "common" {
  source      = "git@github.com:EqualsGroup/terraform-common.git?ref=v1.2.x"
  service     = "bulk-email"
  environment = local.environment
  project     = "EqualsGroup/bulk-email-node"
}

locals {
  account_name     = terraform.workspace
  account          = module.aws_accounts.meta.accounts[local.account_name]
  environment      = local.account.org_name
  aws_account_id   = local.account.id
  resource_name    = module.common.resource_name
  provisioner_role = "${module.common.tags.Organisation}@${module.common.tags.Service}@provisioner"
  deployer_role    = "${module.common.tags.Organisation}@${module.common.tags.Service}@deployer"

  environmentdeploy = {
    shared = {
      ServiceName             = "bulk-email-shared"
      Service                 = "bulk-email"
      AccountId               = module.aws_accounts.meta.accounts.shared-shared.id
      Environment             = module.aws_accounts.meta.accounts.shared-shared.org_name
      platform_version        = "1.4.0"
      port                    = "3000"
      node_env                = "production"
      sendgrid_max_recipients = "1000"
    }
  }
}
