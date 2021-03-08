output "listener_https_arn" {
  value = data.aws_lb_listener.https.arn
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "aws_lb_dns_name" {
  value = data.aws_lb.main.dns_name
}

output "aws_lb_zone_id" {
  value = data.aws_lb.main.zone_id
}

output "security_group_id" {
  value = data.aws_security_group.alb_security_group.id
}

output "aws_lb_target_group_name" {
  value = aws_lb_target_group.main.name
}
