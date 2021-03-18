data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "db_logging" {
  name = "/${var.tags.Service}/${var.tags.Environment}/db-logging"
}