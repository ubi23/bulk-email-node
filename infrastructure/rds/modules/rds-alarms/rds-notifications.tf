# An SNS topic to publish CloudWatch alarms to
resource "aws_sns_topic" "db_alarms" {
  count = var.cw_alarms ? 1 : 0
  name  = replace(substr(join("-", [var.tags.Service, "aurora-db-alarms"]), 0, 255), "/-$/", "")
}

# CloudWatch Metrics
resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.tags.Service}-alarm-rds-database-connections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_eval_period_connections
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.cw_max_conns
  treat_missing_data  = "notBreaching"
  alarm_description   = "RDS Maximum connection Alarm for ${var.cluster_identifier} writer"
  alarm_actions       = [aws_sns_topic.db_alarms[0].id]
  # ok_actions          = [aws_sns_topic.db_alarms[0].id]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
    Role                = "WRITER"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.tags.Service}-alarm-rds-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.cw_eval_period_cpu
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.cw_max_cpu
  treat_missing_data  = "notBreaching"
  alarm_description   = "RDS CPU Alarm for ${var.cluster_identifier} writer"
  alarm_actions       = [aws_sns_topic.db_alarms[0].id]
  # ok_actio ns          = [aws_sns_topic.db_alarms[0].id]

  dimensions = {
    DBClusterIdentifier = var.cluster_identifier
    Role                = "WRITER"
  }
}
