# An SNS topic to publish CloudWatch alarms to
resource "aws_sns_topic" "ecs_alarms" {
  count = var.cw_alarms ? 1 : 0
  name  = replace(substr(join("-", [var.tags.Service, "ecs-alarms"]), 0, 255), "/-$/", "")
}

# CloudWatch Metrics
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.service_name}-alarm-ecs-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_utilization_high_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.cpu_utilization_high_period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationHighThreshold"]
  treat_missing_data  = "missing"

  alarm_description = format(
    var.alarm_description,
    "CPU",
    "High",
    var.cpu_utilization_high_period / 60,
    var.cpu_utilization_high_evaluation_periods
  )
  alarm_actions = [aws_sns_topic.ecs_alarms[0].id]
  ok_actions    = [aws_sns_topic.ecs_alarms[0].id]

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.service_name}-alarm-ecs-memory-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.memory_utilization_high_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.memory_utilization_high_period
  statistic           = "Average"
  threshold           = local.thresholds["MemoryUtilizationHighThreshold"]
  treat_missing_data  = "missing"

  alarm_description = format(
    var.alarm_description,
    "Memory",
    "High",
    var.memory_utilization_high_period / 60,
    var.memory_utilization_high_evaluation_periods
  )
  alarm_actions = [aws_sns_topic.ecs_alarms[0].id]
  ok_actions    = [aws_sns_topic.ecs_alarms[0].id]

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}

resource "aws_cloudwatch_metric_alarm" "running_task_count_0" {
  count               = var.cw_alarms ? 1 : 0
  alarm_name          = "${var.service_name}-alarm-ecs-running_task_count_0"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_utilization_high_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.count_tasks_0
  statistic           = "SampleCount"
  threshold           = "0"
  treat_missing_data  = "breaching"

  alarm_description = "ECS Count task running 0 Alarm for cluster ${var.cluster_name} and service ${var.service_name}"
  alarm_actions     = [aws_sns_topic.ecs_alarms[0].id]
  ok_actions        = [aws_sns_topic.ecs_alarms[0].id]

  dimensions = local.dimensions_map[var.service_name == "" ? "cluster" : "service"]
}
