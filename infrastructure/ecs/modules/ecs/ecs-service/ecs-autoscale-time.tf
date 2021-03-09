
resource "aws_appautoscaling_scheduled_action" "app_autoscale_time_up" {
  name = "app-autoscale-time-up-${var.tags.Service}-appautoscaling"

  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  schedule           = var.scale_up_cron

  scalable_target_action {
    min_capacity = aws_appautoscaling_target.ecs.min_capacity
    max_capacity = aws_appautoscaling_target.ecs.max_capacity
  }
}

resource "aws_appautoscaling_scheduled_action" "app_autoscale_time_down" {
  name  = "app-autoscale-time-down-${var.tags.Service}-appautoscaling"

  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  schedule           = var.scale_down_cron

  scalable_target_action {
    min_capacity = var.scale_down_min_capacity
    max_capacity = var.scale_down_max_capacity
  }
}
