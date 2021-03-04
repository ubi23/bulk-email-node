resource "aws_lb_target_group" "main" {
  name   = replace(substr(join("-", [var.tags.Service, "blue"]), 0, 32), "/-$/", "")
  vpc_id = local.aws_vpc_id

  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = var.target_type

  # The amount of time for Elastic Load Balancing to wait before deregistering a target. The range is 0–3600 seconds.
  deregistration_delay = var.deregistration_delay

  # The time period, in seconds, during which the load balancer sends
  # a newly registered target a linearly increasing share of the traffic to the target group.
  # The range is 30–900 seconds (15 minutes).
  slow_start = var.slow_start

  # Your Application Load Balancer periodically sends requests to its registered targets to test their status.
  health_check {
    path = var.health_check_path

    # The number of consecutive successful/failed health checks required before considering an unhealthy target healthy. The range is 2–10.
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold

    # The amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–60 seconds.
    timeout = var.health_check_timeout

    # The approximate amount of time, in seconds, between health checks of an individual target. The range is 5–300 seconds.
    interval = var.health_check_interval

    # The HTTP codes to use when checking for a successful response from a target.
    matcher = var.health_check_matcher

    # The port the load balancer uses when performing health checks on targets.
    # The default is to use the port on which each target receives traffic from the load balancer.
    port = var.health_check_port

    # The possible protocols are HTTP and HTTPS.
    protocol = var.health_check_protocol
  }

  # A mapping of tags to assign to the resource.
  tags = var.tags
}

# Each rule has a priority. Rules are evaluated in priority order, from the lowest value to the highest value. The priority for the rule between 1 and 50000.
# Leaving it unset will automatically set the rule with next available priority after currently existing highest rule.
# A listener can't have multiple rules with the same priority.

resource "aws_lb_listener_rule" "https" {
  listener_arn = data.aws_lb_listener.https.arn
  priority     = var.listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [var.listener_rule_condition_values]
    }
  }

  # Changing the priority causes forces new resource, then network outage may occur.
  # So, specify resources are created before destroyed.
  lifecycle {
    create_before_destroy = true
  }
}
