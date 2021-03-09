data "aws_lb" "main" {
  name = replace(substr(var.tags.AccountName, 0, 32), "/-$/", "")
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.main.arn
  port              = 443
}

data "aws_security_group" "alb_security_group" {
  name = replace(substr(join("-", [var.tags.AccountName, "alb"]), 0, 255), "/-$/", "")
}

data "aws_vpc" "main" {
  count = var.aws_vpc_id == "" ? 1 : 0
  tags = {
    Environment = var.tags.Environment
    Type        = "main"
  }
}

data "aws_secretsmanager_secret" "oidc" {
  name = "/${var.tags.Service}/${var.tags.Environment}/AUTHENTICATE-OIDC"
}

data "aws_secretsmanager_secret_version" "oidc" {
  secret_id = data.aws_secretsmanager_secret.oidc.id
}
