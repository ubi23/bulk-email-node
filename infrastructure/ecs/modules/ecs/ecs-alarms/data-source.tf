data "aws_lb" "main" {
  name = replace(substr(var.tags.AccountName, 0, 32), "/-$/", "")
}

data "aws_lb_target_group" "green" {
  name = replace(substr(join("-", [var.tags.Service, "green"]), 0, 32), "/-$/", "")
}

data "aws_lb_target_group" "blue" {
  name = replace(substr(join("-", [var.tags.Service, "blue"]), 0, 32), "/-$/", "")
}
