resource "aws_secretsmanager_secret" "sendgrid_api_key" {
  name                    = "/${var.tags.Service}/${var.tags.Environment}/SENDGRID_API_KEY"
  description             = "SENDGRID_API_KEY to send emails"
  recovery_window_in_days = 30 // change to 30 when development is finished 
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "sendgrid_api_key" {
  secret_id     = aws_secretsmanager_secret.sendgrid_api_key.id
  secret_string = <<EOF
{
  "sendgrid_api_key": "pendding to add the key"
}
EOF
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "/${var.tags.Service}/${var.tags.Environment}/db-logging"
  description             = "DB credentials"
  recovery_window_in_days = 30 // change to 30 when development is finished 
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = <<EOF
{
    "username" : "${replace(substr(var.tags.ServiceName, 0, 16), "-", "_")}_admin",
    "password" : "${random_password.db_password.result}",
    "engine" : "${var.dblogging_secret.engine}",
    "engine-version" : "${var.dblogging_secret.engine-version}",
    "port" : "${var.dblogging_secret.port}",
    "host" : "${var.dblogging_secret.host}",
    "dialect" : "${var.dblogging_secret.dialect}",
    "database" : "${var.dblogging_secret.database}",
    "engine-mode" : "${var.dblogging_secret.engine-mode}"
}
EOF
}

resource "random_password" "db_password" {
  length           = 32
  special          = true
  number           = true
  upper            = true
  lower            = true
  min_special      = 5
  min_numeric      = 3
  min_upper        = 3
  min_lower        = 3
  override_special = "!#$%^&*()-_=+<>:?"
  keepers = {
    pass_version = 1
  }
}
