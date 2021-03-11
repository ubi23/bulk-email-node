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
