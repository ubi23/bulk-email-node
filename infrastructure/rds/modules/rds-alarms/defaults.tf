variable "cw_alarms" {
  type        = string
  default     = false
  description = "Whether to enable CloudWatch alarms - requires `cw_sns_topic` is specified"
}

variable "cluster_identifier" {
  type        = string
  default     = ""
  description = "Cluster ID where all  alarms will be related to"
}

variable "cw_eval_period_connections" {
  type        = string
  default     = "1"
  description = "Evaluation period for the DB connections alarms"
}

variable "cw_max_conns" {
  type        = string
  default     = "50"
  description = "Connection count beyond which to trigger a CloudWatch alarm"
}

variable "cw_max_cpu" {
  type        = string
  default     = "85"
  description = "CPU threshold above which to alarm"
}

variable "cw_eval_period_cpu" {
  type        = string
  default     = "2"
  description = "Evaluation period for the DB CPU alarms"
}

variable "cw_max_replica_lag" {
  type        = string
  default     = "2000"
  description = "Maximum Aurora replica lag in milliseconds above which to alarm"
}

variable "cw_eval_period_replica_lag" {
  type        = string
  default     = "5"
  description = "Evaluation period for the DB replica lag alarm"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
