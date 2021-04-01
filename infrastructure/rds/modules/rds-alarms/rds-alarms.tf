# An SNS topic to publish CloudWatch alarms to
resource "aws_sns_topic" "db_alarms" {
  count = var.cw_alarms ? 1 : 0
  name  = replace(substr(join("-", [var.tags.Service, "aurora-db-alarms"]), 0, 255), "/-$/", "")
}

# CloudWatch Metrics
resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU" {
  count               = var.cw_alarms ? 1 : 0
  actions_enabled     = "true"
  alarm_name          = "${var.tags.Service}-alarm-rds-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_eval_period_cpu
  datapoints_to_alarm = var.cw_datapoints_to_alarm
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.cw_period
  statistic           = "Maximum"
  threshold           = var.cw_max_cpu
  treat_missing_data  = "notBreaching"
  alarm_description   = "RDS CPU Alarm for ${var.cluster_identifier} writer"
  alarm_actions       = [aws_sns_topic.db_alarms[0].id]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
    Role                = "WRITER"
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "alb_anomaly_band_active_connections" {
  count               = var.cw_alarms ? 1 : 0
  actions_enabled     = "true"
  alarm_name          = "${var.tags.Service}-alarm-rds-anomaly-database-connections"
  comparison_operator = "LessThanLowerOrGreaterThanUpperThreshold"
  datapoints_to_alarm = var.cw_datapoints_to_alarm
  evaluation_periods  = var.cw_eval_period_connections
  treat_missing_data  = "missing"
  threshold_metric_id = "ad1"
  alarm_description   = "RDS Active connection Alarm for ${var.cluster_identifier}"
  alarm_actions       = [aws_sns_topic.db_alarms[0].id]

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = var.cw_period
      stat        = "Maximum"

      dimensions = {
        DBClusterIdentifier = var.cluster_identifier
        Role                = "WRITER"
      }
    }
  }
  metric_query {
    id          = "ad1"
    expression  = "ANOMALY_DETECTION_BAND(m1, 10)"
    label       = "Active connection count band"
    return_data = "true"
  }
  tags = var.tags
}
