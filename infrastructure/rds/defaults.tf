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

  instanceDetails = {
      backup_retention_period                        = ["30"]          // How long to keep backups for (in days)
      storage_encrypted                              = ["true"]        // Specifies whether the underlying storage layer should be encrypted
      apply_immediately                              = ["true"]        // Determines whether or not any DB modifications are applied immediately, or during the maintenance window
      monitoring_interval                            = ["60"]          // The interval (seconds) between points when Enhanced Monitoring metrics are collected
      iam_database_authentication_enabled            = ["false"]       // Whether to enable IAM database authentication for the RDS Cluster
      delete_protection                              = ["false"]       // We explicitly prevent destruction
      enabled_cloudwatch_logs_exports                = []              // Aurora Serverless currently doesn't support CloudWatch Log Export
      skip_final_snapshot                            = ["true"]
      enable_http_endpoint                           = ["false"]
      scaling_configuration_auto_pause               = ["true"]
      scaling_configuration_max_capacity             = ["2"]
      scaling_configuration_min_capacity             = ["1"]
      scaling_configuration_seconds_until_auto_pause = ["300"]
      scaling_configuration_timeout_action           = ["RollbackCapacityChange"]
  }
}
