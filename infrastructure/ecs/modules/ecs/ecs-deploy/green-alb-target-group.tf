resource "aws_lb_target_group" "green" {
  count = var.ecs_service_name != "" ? 1 : 0
  name  = replace(substr(join("-", [var.tags.Service, "green"]), 0, 32), "/-$/", "")

  vpc_id               = local.aws_vpc_id
  port                 = data.aws_lb_target_group.blue.port
  protocol             = data.aws_lb_target_group.blue.protocol
  target_type          = data.aws_lb_target_group.blue.target_type
  deregistration_delay = data.aws_lb_target_group.blue.deregistration_delay
  slow_start           = data.aws_lb_target_group.blue.slow_start

  health_check {
    path                = data.aws_lb_target_group.blue.health_check[0].path
    healthy_threshold   = data.aws_lb_target_group.blue.health_check[0].healthy_threshold
    unhealthy_threshold = data.aws_lb_target_group.blue.health_check[0].unhealthy_threshold
    timeout             = data.aws_lb_target_group.blue.health_check[0].timeout
    interval            = data.aws_lb_target_group.blue.health_check[0].interval
    matcher             = data.aws_lb_target_group.blue.health_check[0].matcher
    port                = data.aws_lb_target_group.blue.health_check[0].port
    protocol            = data.aws_lb_target_group.blue.health_check[0].protocol
  }

  lifecycle {
    ignore_changes = all
  }

  tags = var.tags
}
