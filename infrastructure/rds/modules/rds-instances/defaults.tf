locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_logging_mysql.secret_string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "subnet_group_name" {
  type        = string
  description = "Name given to DB subnet group"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to use"
}

variable "envname" {
  type        = string
  description = "Environment name (eg,test, stage or prod)"
}

variable "identifier_prefix" {
  type        = string
  default     = ""
  description = "Prefix for cluster and instance identifier"
}

variable "azs" {
  type        = list(string)
  description = "List of AZs to use"
}

variable "publicly_accessible" {
  type        = string
  default     = "false"
  description = "Whether the DB should have a public IP address"
}

variable "final_snapshot_identifier" {
  type        = string
  default     = "final"
  description = "The name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
}

variable "preferred_backup_window" {
  type        = string
  default     = "02:00-04:00"
  description = "When to perform DB backups"
}

variable "preferred_maintenance_window" {
  type        = string
  default     = "mon:04:00-mon:07:00"
  description = "When to perform DB maintenance"
}

variable "port" {
  type        = string
  default     = "3306"
  description = "The port on which to accept connections"
}

variable "auto_minor_version_upgrade" {
  type        = string
  default     = "true"
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
}

variable "db_parameter_group_name" {
  type        = string
  default     = "default.aurora5.6"
  description = "The name of a DB parameter group to use"
}

variable "db_cluster_parameter_group_name" {
  type        = string
  default     = "default.aurora5.6"
  description = "The name of a DB Cluster parameter group to use"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "DB snapshot to create this database from"
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "Specify the KMS Key to use for encryption"
  sensitive   = true
}

variable "performance_insights_enabled" {
  type        = string
  default     = false
  description = "Whether to enable Performance Insights"
}

variable "enabled" {
  type        = string
  default     = true
  description = "Whether the database resources should be created"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of log types to export to CloudWatch Logs. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql."
}

variable "aws_vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID "
}

variable "instanceDetails" {
  type = map(any)
  default = {}
  description = "List of parameters for the instances creation"
}
