# =================================================================
# STEP 1: Output S3 bucket name
# =================================================================
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website_bucket.bucket
}

# =================================================================
# STEP 2: Output S3 bucket website endpoint
# =================================================================
output "s3_bucket_website_endpoint" {
  description = "S3 bucket website endpoint"
  value       = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

# =================================================================
# STEP 3: Output CloudFront distribution ID (needed for CI/CD)
# =================================================================
output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.id
}

# =================================================================
# STEP 4: Output CloudFront distribution domain name
# =================================================================
output "cloudfront_distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

# =================================================================
# STEP 5: Output CloudFront hosted zone ID
# =================================================================
output "cloudfront_distribution_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.hosted_zone_id
}

# =================================================================
# STEP 6: Output ACM certificate ARN
# =================================================================
output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

# =================================================================
# STEP 7: Output Route53 hosted zone ID
# =================================================================
output "route53_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = aws_route53_zone.hosted_zone.zone_id
}

# =================================================================
# STEP 8: Output final website URL
# =================================================================
output "website_url" {
  description = "URL of the website"
  value       = "https://${var.domain_name}"
}
