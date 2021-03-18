# DB Subnet Group creation
resource "aws_db_subnet_group" "main" {
  count       = var.enabled ? 1 : 0
  name        = var.subnet_group_name
  description = "Managed by Terraform"
  subnet_ids  = var.subnets
  tags        = var.tags
}

# Create DB Cluster
resource "aws_rds_cluster" "default" {
  count                               = var.enabled ? 1 : 0
  cluster_identifier                  = format("%s-${var.envname}", var.identifier_prefix)
  availability_zones                  = var.azs
  engine                              = local.db_creds.engine
  engine_version                      = local.db_creds.engine-version
  engine_mode                         = local.db_creds.engine-mode
  database_name                       = local.db_creds.database
  master_username                     = local.db_creds.username
  master_password                     = local.db_creds.password
  final_snapshot_identifier           = "${var.final_snapshot_identifier}-${random_id.server[0].hex}"
  skip_final_snapshot                 = var.instanceDetails.skip_final_snapshot[0]
  backup_retention_period             = var.instanceDetails.backup_retention_period[0]
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  port                                = local.db_creds.port
  db_subnet_group_name                = aws_db_subnet_group.main[0].name
  vpc_security_group_ids              = [aws_security_group.main.id]
  snapshot_identifier                 = var.snapshot_identifier
  storage_encrypted                   = var.instanceDetails.storage_encrypted[0]
  kms_key_id                          = var.instanceDetails.storage_encrypted == "true" ? var.kms_key_id : ""
  apply_immediately                   = var.instanceDetails.apply_immediately[0]
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  iam_database_authentication_enabled = var.instanceDetails.iam_database_authentication_enabled[0]
  enabled_cloudwatch_logs_exports     = var.instanceDetails.enabled_cloudwatch_logs_exports[*]
  deletion_protection                 = var.instanceDetails.delete_protection[0]
  enable_http_endpoint                = var.instanceDetails.enable_http_endpoint[0]

  scaling_configuration {
    auto_pause               = var.instanceDetails.scaling_configuration_auto_pause[0]
    max_capacity             = var.instanceDetails.scaling_configuration_max_capacity[0]
    min_capacity             = var.instanceDetails.scaling_configuration_min_capacity[0]
    seconds_until_auto_pause = var.instanceDetails.scaling_configuration_seconds_until_auto_pause[0]
    timeout_action           = var.instanceDetails.scaling_configuration_timeout_action[0]
  }

  lifecycle {
    ignore_changes = [availability_zones, engine_version]
  }
  tags = var.tags
}

# Geneate an ID when an environment is initialised
resource "random_id" "server" {
  count = var.enabled ? 1 : 0
  keepers = {
    id = aws_db_subnet_group.main[0].name
  }
  byte_length = 8
}


# Push endpoint to secret
resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id     = data.aws_secretsmanager_secret.db_logging.id
  secret_string = <<EOF
{
    "username" : "${local.db_creds.username}",
    "password" : "${local.db_creds.password}",
    "engine" : "${local.db_creds.engine}",
    "engine-version" : "${local.db_creds.engine-version}",
    "engine-mode" : "${local.db_creds.engine-mode}",
    "port" : "${local.db_creds.port}",
    "host" : "${aws_rds_cluster.default[0].endpoint}",
    "dialect" : "${local.db_creds.dialect}",
    "database" : "${local.db_creds.database}"
}
EOF
}
