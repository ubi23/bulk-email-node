resource "aws_security_group" "ecs" {
  name   = replace(substr(join("-", [var.tags.ServiceName, "fargate"]), 0, 255), "/-$/", "")
  vpc_id = local.aws_vpc_id
  tags   = merge(var.tags, { "ecs-security-group-name" : replace(substr(join("-", [var.tags.ServiceName, "fargate"]), 0, 255), "/-$/", "") })
}

## Inbound from loadbalancer
resource "aws_security_group_rule" "loadbalancer" {
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "TCP"
  source_security_group_id = var.source_security_group_id
  description              = "Access from loadbalancer"
  security_group_id        = aws_security_group.ecs.id
}

# outbound to ANYWHERE
resource "aws_security_group_rule" "ecs_outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}
