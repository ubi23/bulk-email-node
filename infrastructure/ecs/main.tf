terraform {
  required_version = ">= 0.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28.0"
    }
  }

  backend "s3" {
    bucket               = "fairfx-terraform-state"
    key                  = "bulk-email-fargate/terraform.tfstate"
    region               = "us-east-1"
    dynamodb_table       = "TerraformLockTable"
    role_arn             = "arn:aws:iam::643417828134:role/FairFXGroup@bulk-email@terraform-state"
    workspace_key_prefix = "bulk-email"
  }
}

module "aws_accounts" {
  source = "git@github.com:EqualsGroup/terraform-aws-accounts.git?ref=v1.0.x"
}

provider "aws" {
  allowed_account_ids = [local.aws_account_id]
  region              = "eu-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::${local.aws_account_id}:role/${local.provisioner_role}"
    session_name = "terraform"
  }
}

provider "aws" {
  allowed_account_ids = [local.dns_aws_account_id]
  region              = "eu-west-2"
  alias               = "dns"

  assume_role {
    role_arn     = "arn:aws:iam::783996378610:role/FairFXGroup@ops-aws-dns"
    session_name = "Terraform"
  }
}
