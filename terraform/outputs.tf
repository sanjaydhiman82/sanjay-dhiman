# =================================================================
# S3 bucket name
# =================================================================
output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}

# =================================================================
# S3 website endpoint
# =================================================================
output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

# =================================================================
# CloudFront ID (for CI/CD)
# =================================================================
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

# =================================================================
# CloudFront domain
# =================================================================
output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

# =================================================================
# ACM cert
# =================================================================
output "acm_certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

# =================================================================
# Website URL
# =================================================================
output "website_url" {
  value = "https://${var.domain_name}"
}