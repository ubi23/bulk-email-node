variable "tags" {
}

variable "application_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  default = []
}

variable "secret_npm_token" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "deployer_role" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_name" {
  type = string
}

variable "environmentdeploy" {
  type = map(map(string))
}

variable "container_name" {
  type = string
}
