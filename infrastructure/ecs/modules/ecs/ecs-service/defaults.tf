variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "aws_service_discovery_private_dns_namespace_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "deployment_maximum_percent" {
  type    = string
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  type    = string
  default = 100
}

variable "aws_lb_listener_https_arn" {
  type        = string
  default     = ""
  description = "required when load balancer is enabled"
}

variable "health_check_grace_period_seconds" {
  type    = number
  default = 30
}

variable "container_protocol" {
  type    = string
  default = "HTTP"
}

variable "container_name" {
  type    = string
  default = ""
}

variable "ecs_cluster_name" {
  type    = string
  default = ""
}

variable "ecs_cluster_id" {
  type    = string
  default = ""
}

variable "service_discovery_name" {
  type    = string
  default = ""
}

variable "max_tasks_multiplier" {
  type    = number
  default = 4
}

# Default scale up at 8 am weekdays, this is UTC so it doesn't adjust to daylight savings
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
variable "scale_up_cron" {
  default = "cron(0 8 ? * MON-FRI *)"
}

# Default scale down at 10 pm every day
variable "scale_down_cron" {
  default = "cron(0 22 ? * * *)"
}

# The mimimum number of containers to scale down to.
# Set this and `scale_down_max_capacity` to 0 to turn off service on the `scale_down_cron` schedule.
variable "scale_down_min_capacity" {
  default = 0
}

# The maximum number of containers to scale down to.
variable "scale_down_max_capacity" {
  default = 0
}

variable "attach_service_discovery" {
  type    = bool
  default = false
}

variable "aws_vpc_id" {
  type    = string
  default = ""
}

variable "aws_lb_target_group_arn" {
  type    = string
  default = ""
}

variable "platform_version" {
  type    = string
  default = "LATEST"
}

variable "ecs_parameters" {
  type = map(string)
  default = {
    max_tasks                    = "3" // leave this as the default (-1), if you would like to use the multiplier (max_tasks_multiplier) instead - this recommended for the equal distribution of tasks across multiple AZs
    min_tasks                    = "1"
    autoscaling_cpu_threshold    = "85" // autoscalling threshold for cpu usage percentag
    autoscaling_memory_threshold = "85" // autoscalling threshold for memory usage percentage
    desired_count                = "1"  // desired number of task running in the cluster
  }
  description = "List of parameters for ecs service"
}

locals {
  container_name         = var.container_name == "" ? var.tags.Service : var.container_name
  ecs_cluster_name       = var.ecs_cluster_name == "" ? var.tags.Name : var.ecs_cluster_name
  service_discovery_name = var.service_discovery_name == "" ? var.tags.Service : var.service_discovery_name
  min_tasks              = var.ecs_parameters.min_tasks < 0 ? length(data.aws_availability_zones.available.zone_ids) : var.ecs_parameters.min_tasks
  max_tasks              = var.ecs_parameters.max_tasks < 0 ? length(data.aws_availability_zones.available.zone_ids) * var.max_tasks_multiplier : var.ecs_parameters.max_tasks
  aws_vpc_id             = var.aws_vpc_id == "" ? data.aws_vpc.main[0].id : var.aws_vpc_id
}
