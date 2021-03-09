locals {
  thresholds = {
    CPUUtilizationHighThreshold    = min(max(var.cpu_utilization_high_threshold, 0), 100)
    MemoryUtilizationHighThreshold = min(max(var.memory_utilization_high_threshold, 0), 100)
  }

  dimensions_map = {
    "service" = {
      "ClusterName" = var.cluster_name
      "ServiceName" = var.service_name
    }
    "cluster" = {
      "ClusterName" = var.cluster_name
    }
  }
}

variable "cw_alarms" {
  type        = string
  default     = false
  description = "Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster to monitor"
}

variable "service_name" {
  type        = string
  description = "The name of the ECS Service in the ECS cluster to monitor"
  default     = ""
}

variable "alarm_description" {
  type        = string
  description = "The string to format and use as the alarm description."
  default     = "Average service %v utilization %v last %d minute(s) over %v period(s)"
}

variable "cpu_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of CPU utilization average"
  default     = 85
}

variable "cpu_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "cpu_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}

variable "count_tasks_0" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 60
}

variable "memory_utilization_high_threshold" {
  type        = number
  description = "The maximum percentage of Memory utilization average"
  default     = 85
}

variable "memory_utilization_high_evaluation_periods" {
  type        = number
  description = "Number of periods to evaluate for the alarm"
  default     = 1
}

variable "memory_utilization_high_period" {
  type        = number
  description = "Duration in seconds to evaluate for the alarm"
  default     = 300
}
