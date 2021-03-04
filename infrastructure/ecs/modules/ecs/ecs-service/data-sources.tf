data "aws_vpc" "main" {
  count = var.aws_vpc_id == "" ? 1 : 0
  tags = {
    Environment = var.tags.Environment
    Type        = "main"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = local.aws_vpc_id

  tags = {
    Tier = "private"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# data "aws_caller_identity" "current" {}

data "aws_security_group" "ecs" {
  id = var.ecs_security_group_id
}
