locals {
  aws_vpc_id = var.aws_vpc_id == "" ? data.aws_vpc.main[0].id : var.aws_vpc_id
}

variable "aws_vpc_id" {
  type    = string
  default = ""
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

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_healthy_threshold" {
  type    = number
  default = 3
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_matcher" {
  type    = number
  default = 200
}

variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

variable "health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "tags" {
}

variable "listener_rule_priority" {
  type        = number
  default     = null
  description = "Leaving it unset will automatically set the rule with next available priority after currently existing highest rule."
}

variable "listener_rule_condition_values" {
}
