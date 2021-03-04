resource "aws_route53_record" "api_endpoint" {
  provider        = aws.dns
  zone_id         = data.aws_route53_zone.api_domain.zone_id
  name            = local.api_endpoint
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = module.ecs_loadbalancer.aws_lb_dns_name
    zone_id                = module.ecs_loadbalancer.aws_lb_zone_id
    evaluate_target_health = false
  }
}
