# create the SNS topic for manual approval notifications
resource "aws_sns_topic" "approval" {
  name = replace(substr(join("-", [var.tags.Service, "deployment-approval"]), 0, 255), "/-$/", "")
}
