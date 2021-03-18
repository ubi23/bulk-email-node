variable "environmentdeploy" {
  type = map(map(string))
}

variable "stage_build_name" {
  default = ""
  type    = string
}

variable "stage_test_name" {
  default = ""
  type    = string
}

variable "stage_teams_deploy_name" {
  default = ""
  type    = string
}

variable "repo" {
  type = string
}

variable "owner" {
  type = string
}

variable "secret_github_token" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "deployer_role" {
  type = string
}

variable "branch" {
  type = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
