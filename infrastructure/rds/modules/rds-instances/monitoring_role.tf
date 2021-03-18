# IAM Role + Policy attach for Enhanced Monitoring
data "aws_iam_policy_document" "monitoring-rds-assume-role-policy" {
  count = var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds-enhanced-monitoring" {
  count              = var.enabled && var.instanceDetails.monitoring_interval[0] > 0 ? 1 : 0
  name_prefix        = replace(substr(join("-", [var.tags.Service, "rds-monitoring-"]), 0, 32), "/-$/", "")
  assume_role_policy = data.aws_iam_policy_document.monitoring-rds-assume-role-policy[0].json
}

resource "aws_iam_role_policy_attachment" "rds-enhanced-monitoring-policy-attach" {
  count      = var.enabled && var.instanceDetails.monitoring_interval[0] > 0 ? 1 : 0
  role       = aws_iam_role.rds-enhanced-monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
