data "aws_security_group" "fargate" {
  name = replace(substr(join("-", [var.tags.ServiceName, "fargate"]), 0, 255), "/-$/", "")
}

data "aws_secretsmanager_secret" "db_logging" {
  name = "/${var.tags.Service}/${var.tags.Environment}/db-logging"
}

data "aws_secretsmanager_secret_version" "db_logging_mysql" {
  secret_id = data.aws_secretsmanager_secret.db_logging.id
}
