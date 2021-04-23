resource "aws_cloudwatch_metric_alarm" "target_errors_count" {
  count               = var.cw_alarms ? 1 : 0
  actions_enabled     = "true"
  alarm_name          = "${var.tags.Service}-alarm-target-errors-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.errors_count_evaluation_periods
  threshold           = "0"
  alarm_description   = "Request error rate on ALB was exceeded"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.ecs_alarms[0].id]

  metric_query {
    id          = "e1"
    expression  = "m1green+m1blue+m2green+m2blue+m3green+m3blue+m4green+m4blue"
    label       = "Target Groups Errors Count"
    return_data = "true"
  }
  metric_query {
    id = "m1green"
    metric {
      metric_name = "UnHealthyHostCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.green.arn_suffix
      }
    }
  }
  metric_query {
    id = "m1blue"
    metric {
      metric_name = "UnHealthyHostCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.blue.arn_suffix
      }
    }
  }
  metric_query {
    id = "m2blue"
    metric {
      metric_name = "TargetTLSNegotiationErrorCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.blue.arn_suffix
      }
    }
  }
  metric_query {
    id = "m2green"
    metric {
      metric_name = "TargetTLSNegotiationErrorCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.green.arn_suffix
      }
    }
  }
  metric_query {
    id = "m3blue"
    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.blue.arn_suffix
      }
    }
  }
  metric_query {
    id = "m3green"
    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.green.arn_suffix
      }
    }
  }
  metric_query {
    id = "m4blue"
    metric {
      metric_name = "TargetConnectionErrorCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.blue.arn_suffix
      }
    }
  }
  metric_query {
    id = "m4green"
    metric {
      metric_name = "TargetConnectionErrorCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
        TargetGroup  = data.aws_lb_target_group.green.arn_suffix
      }
    }
  }
  tags = var.tags
}
