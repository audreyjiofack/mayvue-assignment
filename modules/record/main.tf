resource "aws_route53_record" "blue" {
  zone_id        = var.config.route53_zone_id
  name           = var.config.app_dns_name
  type           = "CNAME"
  ttl            = 60
  set_identifier = "blue"
  weighted_routing_policy {
    weight = 100
  }
  records = [module.blue_app.public_dns]
}

resource "aws_route53_record" "green" {
  zone_id        = var.config.route53_zone_id
  name           = var.config.app_dns_name
  type           = "CNAME"
  ttl            = 60
  set_identifier = "green"

  weighted_routing_policy {
    weight = 0
  }
  records = [module.green_app.public_dns]
}
