# Log group for ecs
resource "aws_cloudwatch_log_group" "ecsloggroup" {
  name              = "/ecs/${replace(substr(var.tags.ServiceName, 0, 255), "/-$/", "")}"
  retention_in_days = 90
  tags              = var.tags
}

# Create Service Discovery for ECS
resource "aws_service_discovery_service" "main" {
  count = var.attach_service_discovery == true ? 1 : 0
  name  = local.service_discovery_name

  dns_config {
    namespace_id = var.aws_service_discovery_private_dns_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
}

#ECS service for FARGATE cluster with loadbalancer and deployment blue/green
resource "aws_ecs_service" "with_lb_deployment" {
  name                              = substr("${var.tags.Service}-service", 0, 255)
  cluster                           = var.ecs_cluster_id
  task_definition                   = aws_ecs_task_definition.task_definition_app.arn
  desired_count                     = var.ecs_parameters.desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = "FARGATE"
  platform_version                  = var.platform_version == "" ? "LATEST" : var.platform_version
  tags                              = var.tags
  enable_ecs_managed_tags           = true
  propagate_tags                    = "SERVICE"
  scheduling_strategy               = "REPLICA"

  deployment_maximum_percent = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    subnets          = data.aws_subnet_ids.private.ids
    security_groups  = [data.aws_security_group.ecs.id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = local.container_name
    container_port   = var.ecs_parameters.container_port
  }

  dynamic "service_registries" {
    for_each = var.attach_service_discovery ? toset([0]) : toset([])
    content {
      registry_arn = aws_service_discovery_service.main[0].arn
    }
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count, load_balancer]
  }
}
