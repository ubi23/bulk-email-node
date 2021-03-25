resource "aws_codedeploy_app" "main" {
  count            = var.ecs_service_name != "" ? 1 : 0
  compute_platform = "ECS"
  name             = substr("${var.tags.Service}-${var.tags.Environment}", 0, 255)
}

resource "aws_codedeploy_deployment_group" "main" {
  count                  = var.ecs_service_name != "" ? 1 : 0
  app_name               = aws_codedeploy_app.main[0].name
  deployment_group_name  = aws_codedeploy_app.main[0].name
  service_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/${var.deployer_role}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = var.auto_rollback_enabled
    events  = var.auto_rollback_events
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = var.action_on_timeout
      wait_time_in_minutes = var.action_on_timeout == "CONTINUE_DEPLOYMENT" ? null : var.wait_time_in_minutes
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.tags.Environment == "shared" ? var.termination_wait_time_in_minutes : 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.lb_listener_arn]
      }
      target_group {
        name = var.blue_lb_target_group_name
      }

      target_group {
        name = aws_lb_target_group.green[0].name
      }

      test_traffic_route {
        listener_arns = var.test_traffic_route_listener_arns
      }
    }
  }

  alarm_configuration {
    alarms  = [
      "${var.tags.Service}-alarm-ecs-cpu-utilization-high",
      "${var.tags.Service}-alarm-ecs-memory-utilization-high",
      "${var.tags.Service}-alarm-rds-anomaly-database-connections",
      "${var.tags.Service}-alarm-rds-cpu",
      "${var.tags.Service}-alarm-alb-errors-count",
      "${var.tags.Service}-alarm-alb-anomaly-active-connections",
      "${var.tags.Service}-alarm-target-errors-count"
    ]
    enabled = true
    ignore_poll_alarm_failure = false
  }

  lifecycle {
    ignore_changes = [load_balancer_info]
  }
}
