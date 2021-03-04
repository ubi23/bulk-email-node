data "aws_vpc" "main" {
  count = var.aws_vpc_id == "" ? 1 : 0
  tags = {
    Environment = var.tags.Environment
    Type        = "main"
  }
}

data "aws_lb_target_group" "blue" {
  name = var.blue_lb_target_group_name
}

