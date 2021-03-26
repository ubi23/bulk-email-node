# create the SNS topic for manual approval notifications and pipeline alarms 
resource "aws_sns_topic" "pipeline" {
  name = replace(substr(join("-", [var.tags.Service, "pipeline"]), 0, 255), "/-$/", "")
}

data "aws_iam_policy_document" "notif_access" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [aws_sns_topic.pipeline.arn]
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.pipeline.arn
  policy = data.aws_iam_policy_document.notif_access.json
}

## Notifications CodePipeline
resource "aws_codestarnotifications_notification_rule" "pipeline" {
  detail_type = "FULL"
  event_type_ids = [
    "codepipeline-pipeline-manual-approval-needed",
    "codepipeline-pipeline-action-execution-failed",
    # "codepipeline-pipeline-manual-approval-succeeded",
    "codepipeline-pipeline-pipeline-execution-succeeded"
  ]
  status   = var.cw_alarms
  name     = replace(substr(join("-", [var.tags.Service, "codepipeline-notify"]), 0, 255), "/-$/", "")
  resource = aws_codepipeline.main.arn

  target {
    address = aws_sns_topic.pipeline.arn
  }
  tags = var.tags
}

# ## Notifications CodeBuild
# resource "aws_codestarnotifications_notification_rule" "build" {
#   detail_type = "FULL"
#   event_type_ids = [
#     "codebuild-project-build-state-failed"
#   ]

#   name     = replace(substr(join("-", [var.tags.Service, "codebuild-notify"]), 0, 255), "/-$/", "")
#   resource = var.codebuild_arn
# status = var.cw_alarms
#   target {
#     address = aws_sns_topic.pipeline.arn
#   }
# tags = var.tags
# }

## Notifications CodeDeploy
# resource "aws_codestarnotifications_notification_rule" "deploy" {
#   detail_type    = "BASIC"
#   event_type_ids = [
#     "codedeploy-application-deployment-failed",
#     "codedeploy-application-deployment-succeeded",
#     ]

#   name     = "codedeploy-notify"
#   resource = aws_codepipeline.main.arn
# status = var.cw_alarms
#   target {
#     address = aws_sns_topic.pipeline.arn
#   }
# tags = var.tags
# }
