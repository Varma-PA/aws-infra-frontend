output "cdn_output" {
  value = aws_cloudfront_distribution.s3_cdn_distribution.id
}
