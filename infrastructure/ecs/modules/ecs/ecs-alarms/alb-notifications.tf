resource "aws_cloudwatch_metric_alarm" "alb_errors_count" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.tags.Service}-alarm-alb-errors-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "0"
  alarm_description   = "Request error rate on ALB was exceeded"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.ecs_alarms[0].id]

  metric_query {
    id          = "e1"
    expression  = "m1+m2+m3+m4+m5+m6"
    label       = "ALB Errors Count"
    return_data = "true"
  }
  metric_query {
    id = "m1"
    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m3"
    metric {
      metric_name = "RejectedConnectionCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m4"
    metric {
      metric_name = "HTTP_Redirect_Url_Limit_Exceeded_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m5"
    metric {
      metric_name = "DroppedInvalidHeaderRequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
  metric_query {
    id = "m6"
    metric {
      metric_name = "ForwardedInvalidHeaderRequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      dimensions = {
        LoadBalancer = data.aws_lb.main.arn_suffix
      }
    }
  }
}
