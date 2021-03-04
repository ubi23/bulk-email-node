provider "github" {
  token        = var.secret_github_token
  organization = var.owner
}

resource "aws_codepipeline_webhook" "main" {
  name            = replace(substr(join("-", [var.tags.ServiceName, "deploy"]), 0, 100), "/-$/", "")
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.main.name

  authentication_configuration {
    secret_token = var.secret_github_token
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.branch}"
  }
}

resource "github_repository_webhook" "main" {
  active     = true
  repository = var.repo

  configuration {
    url          = aws_codepipeline_webhook.main.url
    content_type = "json"
    insecure_ssl = false
    secret       = var.secret_github_token
  }

  events = ["push"]
}
