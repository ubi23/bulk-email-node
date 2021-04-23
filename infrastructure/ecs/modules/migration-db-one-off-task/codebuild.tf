resource "aws_cloudwatch_log_group" "ci_db" {
  name              = "/aws/codebuild/${var.tags.Name}-db-migration"
  retention_in_days = 30
}

resource "aws_codebuild_project" "main" {
  name          = replace(substr(join("-", [var.tags.Name, "db-migration"]), 0, 255), "/-$/", "")
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
      name  = "ECS_CLUSTER"
      value = var.ecs_cluster_name
    }
    environment_variable {
      name  = "ECS_TASK_DEFINITION"
      value = aws_ecs_task_definition.task_definition_db_migration.family
    }
    environment_variable {
      name  = "ECS_SUBNETS_IDS"
      value = local.subnets
    }
    environment_variable {
      name  = "ECS_SECURITY_GROUPS"
      value = var.security_group_id
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.ci_db.name
    }
  }

  source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    buildspec           = file("${path.module}/config/buildspec-db-migration.yml")
    report_build_status = false
    insecure_ssl        = false
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = local.subnet_ids
    security_group_ids = [var.security_group_id]
  }
}
