resource "aws_appautoscaling_target" "ecs" {
  service_namespace  = "ecs"
  resource_id        = "service/${local.ecs_cluster_name}/${aws_ecs_service.with_lb_deployment.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = local.max_tasks
  min_capacity       = local.min_tasks
  depends_on         = [ aws_ecs_service.with_lb_deployment ]
}

resource "aws_appautoscaling_policy" "ecs_cpu" {
  name               = "cpu-autoscaling"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.ecs_parameters.autoscaling_cpu_threshold
    scale_in_cooldown  = 900
    scale_out_cooldown = 180
  }
}

resource "aws_appautoscaling_policy" "ecs_memory" {
  name               = "memory-autoscaling"
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.ecs_parameters.autoscaling_memory_threshold
    scale_in_cooldown  = 900
    scale_out_cooldown = 180
  }
}
