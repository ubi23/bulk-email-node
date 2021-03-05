resource "aws_security_group" "main" {
  name        = replace(substr(join("-", [var.tags.ServiceName, "pipeline"]), 0, 255), "/-$/", "")
  description = "Traffic for CodeBuild"
  vpc_id      = var.vpc_id

  ingress {
    description = "Traffic for CodeBuild"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = merge(var.tags, { "Name" : replace(substr(join("-", [var.tags.ServiceName, "pipeline"]), 0, 255), "/-$/", "") })
}

