resource "aws_cloudwatch_metric_alarm" "alb_errors_count" {
  count               = var.cw_alarms ? 1 : 0
  actions_enabled     = "true"
  alarm_name          = "${var.tags.Service}-alarm-alb-errors-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.errors_count_evaluation_periods
  threshold           = "0"
  alarm_description   = "Request error rate on ALB was exceeded"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.ecs_alarms[0].id]

  metric_query {
    id          = "e1"
    expression  = "m1+m2+m3+m4+m5"
    label       = "ALB Errors Count"
    return_data = "true"
  }
  metric_query {
    id = "m1"
    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "RejectedConnectionCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m3"
    metric {
      metric_name = "HTTP_Redirect_Url_Limit_Exceeded_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m4"
    metric {
      metric_name = "DroppedInvalidHeaderRequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m5"
    metric {
      metric_name = "ForwardedInvalidHeaderRequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.errors_count_period
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "alb_anomaly_active_connections" {
  count               = var.cw_alarms ? 1 : 0
  actions_enabled     = "true"
  alarm_description   = "Anomaly band for active count of connections"
  alarm_name          = "${var.tags.Service}-alarm-alb-anomaly-active-connections"
  comparison_operator = "LessThanLowerOrGreaterThanUpperThreshold"
  datapoints_to_alarm = var.anomaly_active_connections_datapoints
  evaluation_periods  = var.anomaly_active_connections_evaluation_periods
  treat_missing_data  = "missing"
  threshold_metric_id = "ad1"

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "ActiveConnectionCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.anomaly_active_connections_period
      stat        = "Sum"

      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id          = "ad1"
    expression  = "ANOMALY_DETECTION_BAND(m1, 12)" // the second parameter is the standard deviations to use for the band, default is 2
    label       = "Active connection count band"
    return_data = "true"
  }
  tags = var.tags
}
