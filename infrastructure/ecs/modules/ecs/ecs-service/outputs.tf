output "ecs_service_name" {
  value       = join("", aws_ecs_service.with_lb_deployment.*.name)
  description = "The name of the service."
}

output "task_execution_role_arn" {
  value       = join("", aws_iam_role.task_execution_role.*.arn)
  description = "Task execution role arn"
}

output "task_role_arn" {
  value       = join("", aws_iam_role.task_role.*.arn)
  description = "Task role arn"
}

output "ecs_log_group_name" {
  value       = join("", aws_cloudwatch_log_group.ecsloggroup.*.name)
  description = "ECS log group name"
}
