resource "aws_codepipeline" "main" {
  name     = replace(substr(join("-", [var.tags.Service, "pipeline"]), 0, 100), "/-$/", "")
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.deployer_role}"

  artifact_store {
    location = aws_s3_bucket.releases.id
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_key.by_alias.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceGIT"]

      configuration = {
        Owner                = var.owner
        Repo                 = var.repo
        Branch               = var.branch
        OAuthToken           = var.secret_github_token
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceGIT"]
      output_artifacts = ["node", "configfiles"]
      version          = "1"

      configuration = {
        ProjectName = var.stage_build_name
      }
      run_order = 3
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["node", "configfiles"]
      region          = "eu-west-2"

      configuration = {
        ApplicationName                = var.environmentdeploy.shared.ServiceName
        DeploymentGroupName            = var.environmentdeploy.shared.ServiceName
        TaskDefinitionTemplateArtifact = "configfiles"
        AppSpecTemplateArtifact        = "configfiles"
        TaskDefinitionTemplatePath     = "task-definition.json"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "node"
        Image1ContainerName            = "IMAGE1_NAME"
      }
      run_order = 4
    }
  }
  # Workaround for Terraform insisting on "updating" OAuthToken every run.
  lifecycle {
    ignore_changes = [stage[0].action[0].configuration.OAuthToken]
  }
  tags = var.tags
}
