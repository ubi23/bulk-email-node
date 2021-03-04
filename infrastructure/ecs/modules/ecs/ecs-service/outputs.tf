output "ecs_service_name" {
  value       = join("", aws_ecs_service.with_lb_deployment.*.name)
  description = "The name of the service."
}
