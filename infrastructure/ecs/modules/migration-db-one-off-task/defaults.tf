locals {
  container_name = var.container_name == "" ? var.tags.Service : var.container_name
  subnets        = join(",", [for s in var.subnet_ids : s.id])
  subnet_ids     = [for s in var.subnet_ids : s.id]
}

variable "container_name" {
  type    = string
  default = ""
}

variable "container_port" {
  type    = number
  default = 80
}

variable "task_execution_role" {
  type = string
}

variable "task_role" {
  type = string
}

variable "ecs_log_group_name" {
  type = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "task_definition_command" {
  description = "Command execute in task definition"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
}

variable "ecs_cluster_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "deployer_role" {
  type = string
}

variable "security_group_id" {
  type = string
}
