data "aws_secretsmanager_secret" "github_token" {
  name = "/common/ci/github-token"
}

data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

data "aws_secretsmanager_secret" "sendgrid_api_key" {
  name = "/${module.common.tags.Service}/${module.common.tags.Environment}/SENDGRID_API_KEY"
}

data "aws_vpc" "main" {
  tags = {
    Environment = local.environment
    Type        = "main"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "private"
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}
