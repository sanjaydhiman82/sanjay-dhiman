# =================================================================
# STEP 1: Define AWS region variable
# =================================================================
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

# =================================================================
# STEP 2: Define S3 bucket name variable
# =================================================================
variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
  default     = "www.sanjaydhiman.com"
}

# =================================================================
# STEP 3: Define domain name variable
# =================================================================
variable "domain_name" {
  description = "Custom domain name for the website"
  type        = string
  default     = "www.sanjaydhiman.com"
}

# =================================================================
# STEP 4: Define project name variable
# =================================================================
variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "sanjay-dhiman"
}

# =================================================================
# STEP 5: Define environment variable
# =================================================================
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}
