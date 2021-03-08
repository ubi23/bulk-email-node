variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "aws_vpc_id" {
  type    = string
  default = ""
}

variable "port" {
  type    = number
  default = 80
}

variable "source_security_group_id" {
  type = string
}

locals {
  aws_vpc_id = var.aws_vpc_id == "" ? data.aws_vpc.main[0].id : var.aws_vpc_id
}
