locals {
  aws_vpc_id = var.aws_vpc_id == "" ? data.aws_vpc.main[0].id : var.aws_vpc_id
}

variable "aws_vpc_id" {
  type    = string
  default = ""
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "lb_listener_arn" {
  type = string
}

variable "auto_rollback_enabled" {
  type    = bool
  default = true
}

variable "auto_rollback_events" {
  default = ["DEPLOYMENT_FAILURE"]
}

variable "action_on_timeout" {
  type    = string
  default = "STOP_DEPLOYMENT"
}

variable "wait_time_in_minutes" {
  type    = number
  default = 5
}

variable "termination_wait_time_in_minutes" {
  type    = number
  default = 1
}

variable "test_traffic_route_listener_arns" {
  default = []
}

variable "aws_account_id" {
  type = string
}

variable "deployer_role" {
  type = string
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "target_type" {
  type    = string
  default = "ip"
}

variable "deregistration_delay" {
  type    = number
  default = 65
}

variable "slow_start" {
  type    = number
  default = 0
}

variable "blue_lb_target_group_name" {
  type = string
}

variable "listener_rule_priority" {
  type        = number
  default     = null
  description = "Leaving it unset will automatically set the rule with next available priority after currently existing highest rule."
}

variable "listener_rule_condition_values" {
}
