module "common" {
  source        = "git@github.com:EqualsGroup/terraform-common.git?ref=v1.2.x"
  service       = "bulk-email"
  environment   = local.environment
  project       = "EqualsGroup/bulk-email-node"
}

locals {
  account_name           = terraform.workspace
  account                = module.aws_accounts.meta.accounts[local.account_name]
  environment            = local.account.org_name
  aws_account_id         = local.account.id
  resource_name          = module.common.resource_name
  provisioner_role       = "${module.common.tags.Organisation}@${module.common.tags.Service}@provisioner"
  deployer_role          = "${module.common.tags.Organisation}@${module.common.tags.Service}@deployer"

  environmentdeploy = {
    shared = {
      ServiceName = "bulk-email-shared"
      Environment = module.aws_accounts.meta.accounts.shared-shared.org_name
      AccountId   = module.aws_accounts.meta.accounts.shared-shared.id
      AccountName = "shared-shared"
      node_env    = "production" 
    }
  }
}
