data "aws_route53_zone" "selected" {
  name = "dev.achyuthvarma.me"
}

resource "aws_route53_record" "myrecord" {
  # depends_on = [
  #   aws_instance.webapp-instance
  # ]
  name    = "dev.achyuthvarma.me"
  zone_id = data.aws_route53_zone.selected.zone_id
  # zone_id = var.route53_zone_id
  type = "A"

  # records = [aws_instance.webapp-instance.public_ip]

  # ttl  = 60
  alias {
    name                   = aws_cloudfront_distribution.s3_cdn_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_cdn_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "certifying_dns" {
  #   allow_overwrite = true
  name = tolist(aws_acm_certificate.aws_certificate_manager.domain_validation_options)[0].resource_record_name
  #   name = "dev.achyuthvarma.me"
  records = [tolist(aws_acm_certificate.aws_certificate_manager.domain_validation_options)[0].resource_record_value]
  type    = tolist(aws_acm_certificate.aws_certificate_manager.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.selected.zone_id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "hello_cert_validate" {
  certificate_arn         = aws_acm_certificate.aws_certificate_manager.arn
  validation_record_fqdns = [aws_route53_record.certifying_dns.fqdn]
}