#Create an ACM Certificate
resource "aws_acm_certificate" "aws_certificate_manager" {
  domain_name       = "dev.achyuthvarma.me"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}