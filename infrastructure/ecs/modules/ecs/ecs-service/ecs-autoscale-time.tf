resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  resource_id        = "service/${local.ecs_cluster_name}/${aws_ecs_service.with_lb_deployment.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = local.max_tasks
  min_capacity       = local.min_tasks
  depends_on         = [ aws_ecs_service.with_lb_deployment ]
}

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
