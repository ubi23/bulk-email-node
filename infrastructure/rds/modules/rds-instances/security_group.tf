resource "aws_security_group" "main" {
  name   = replace(substr(join("-", [var.tags.ServiceName, "aurora"]), 0, 255), "/-$/", "")
  vpc_id = var.aws_vpc_id
  tags   = merge(var.tags, { "Name" : replace(substr(join("-", [var.tags.ServiceName, "aurora"]), 0, 255), "/-$/", "") })
}

# Inbound from ecs
resource "aws_security_group_rule" "aurora_inbound_ecs" {
  type      = "ingress"
  from_port = var.port
  to_port   = var.port
  protocol  = "TCP"
  source_security_group_id = data.aws_security_group.fargate.id
  description              = "Access from ecs cluster"
  security_group_id        = aws_security_group.main.id
}

# Outbound to ANYWHERE
resource "aws_security_group_rule" "aurora_outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}
