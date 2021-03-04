resource "aws_cloudwatch_log_group" "ci" {
  name              = "/aws/codebuild/${var.tags.Name}-fargate"
  retention_in_days = 30
}

resource "aws_codebuild_project" "main" {
  name          = replace(substr(join("-", [var.tags.Name, "fargate"]), 0, 255), "/-$/", "")
  description   = var.tags.Name
  build_timeout = 60
  service_role  = "arn:aws:iam::${var.aws_account_id}:role/${var.deployer_role}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "232181100491"
    }
    environment_variable {
      name  = "CONTAINERNAME"
      value = var.container_name
    }
    environment_variable {
      name  = "SECRET_NPM_TOKEN"
      value = var.secret_npm_token
    }
    environment_variable {
      name  = "APPLICATION_NAME"
      value = var.application_name
    }

    dynamic "environment_variable" {
      for_each = var.environmentdeploy.shared

      content {
        name  = "${upper(environment_variable.key)}_DEVELOP"
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.ci.name
    }
  }

  source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    buildspec           = file("./config/buildspec.yml")
    report_build_status = false
    insecure_ssl        = false

  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnet_ids
    security_group_ids = aws_security_group.main[*].id
  }
}
