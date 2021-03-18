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

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "public"
  }
}

data "aws_acm_certificate" "fairfx" {
  domain   = var.ecs_parameters[local.environment].domain
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "service_discovery_namespace" {
  name         = var.ecs_parameters[local.environment].service_discovery_domain
  private_zone = true
}

data "aws_route53_zone" "api_domain" {
  provider     = aws.dns
  name         = "${var.ecs_parameters[local.environment].domain}."
  private_zone = false
}
