# 🚀 Terraform Infrastructure - Static Website Deployment

This directory contains all Terraform configuration files for deploying a production-grade static website hosting infrastructure on AWS.

## 📁 File Structure

```
terraform/
├── main.tf              # Main infrastructure configuration
├── variables.tf         # Variable definitions with defaults
├── terraform.tfvars     # Actual variable values (environment-specific)
├── outputs.tf           # Output values after deployment
└── README.md            # This file
```

---

## 📄 File Descriptions

### 1. **main.tf**

**Purpose**: Contains the core infrastructure definitions and resource configurations for all AWS services.

**Components**:
- **Terraform Block**: Specifies required providers (AWS provider v5.0+)
- **Provider Block**: Configures AWS provider with region variable
- **S3 Bucket Resources**:
  - `aws_s3_bucket`: Creates the S3 bucket for static hosting
  - `aws_s3_bucket_ownership_controls`: Sets object ownership to bucket owner
  - `aws_s3_bucket_public_access_block`: Configures public access settings
  - `aws_s3_bucket_acl`: Sets bucket ACL to public-read
  - `aws_s3_bucket_website_configuration`: Enables static website hosting
  - `aws_s3_bucket_policy`: Allows public read access to bucket objects
- **ACM Certificate Resources**:
  - `aws_acm_certificate`: Creates SSL/TLS certificate for domain
  - `aws_route53_zone`: Creates hosted zone for DNS management
  - `aws_route53_record`: Creates DNS validation records for ACM
  - `aws_acm_certificate_validation`: Validates certificate via DNS
- **CloudFront Resources**:
  - `aws_cloudfront_distribution`: Creates CDN distribution with HTTPS
- **Route53 Resources**:
  - `aws_route53_record` (root): A record pointing to CloudFront
  - `aws_route53_record` (www): A record for www subdomain pointing to CloudFront

**Dependencies**:
- Depends on variables from `variables.tf`
- S3 bucket policy depends on ownership controls and public access blocks
- ACM validation depends on Route53 validation records
- CloudFront depends on ACM certificate validation
- Route53 records depend on CloudFront distribution

**Key Features**:
- Automatic SSL certificate provisioning and validation
- CloudFront cache invalidation support
- Custom error handling (403/404 → index.html)
- IPv6 support
- Compression enabled
- Price class optimization (PriceClass_100 for cost savings)

---

### 2. **variables.tf**

**Purpose**: Defines all input variables used in `main.tf` with descriptions, types, and default values.

**Variables Defined**:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | string | `ap-south-1` | AWS region for deployment |
| `bucket_name` | string | `www.sanjaydhiman.com` | Unique name for the S3 bucket |
| `domain_name` | string | `sanjaydhiman.com` | Custom domain name for the website |
| `project_name` | string | `sanjay-dhiman-website` | Project name for tagging |
| `environment` | string | `prod` | Environment (dev, staging, prod) |

**Dependencies**:
- No dependencies (standalone file)
- Referenced by `main.tf` for resource configuration
- Can be overridden by `terraform.tfvars`

**Usage**:
- Provides default values for quick deployment
- Allows customization without modifying `main.tf`
- Enables environment-specific configurations (dev/staging/prod)

---

### 3. **terraform.tfvars**

**Purpose**: Contains actual values for variables defined in `variables.tf`. This file is environment-specific and should NOT be committed to version control (add to .gitignore).

**Current Configuration**:
```hcl
aws_region   = "ap-south-1"
bucket_name  = "www.sanjaydhiman.com"
domain_name  = "sanjaydhiman.com"
project_name = "sanjay-dhiman-website"
environment  = "prod"
```

**Dependencies**:
- Depends on variable definitions in `variables.tf`
- Overrides default values in `variables.tf`
- Loaded automatically by Terraform when present

**Security Note**:
- This file often contains sensitive information
- Should be added to `.gitignore`
- Use different `.tfvars` files for different environments (e.g., `dev.tfvars`, `prod.tfvars`)

---

### 4. **outputs.tf**

**Purpose**: Defines what information Terraform should display after successful deployment. These outputs are used for:
- Displaying important resource identifiers
- Providing values needed for CI/CD configuration
- Documenting the deployed infrastructure

**Outputs Defined**:

| Output | Description |
|--------|-------------|
| `s3_bucket_name` | Name of the created S3 bucket |
| `s3_bucket_website_endpoint` | Direct S3 website endpoint (for testing) |
| `cloudfront_distribution_id` | CloudFront distribution ID (needed for cache invalidation) |
| `cloudfront_distribution_domain_name` | CloudFront distribution domain name |
| `cloudfront_distribution_hosted_zone_id` | Hosted zone ID for DNS configuration |
| `acm_certificate_arn` | ARN of the SSL certificate |
| `route53_zone_id` | Route53 hosted zone ID |
| `website_url` | Final website URL (https://domain.com) |

**Dependencies**:
- Depends on resources created in `main.tf`
- References resource attributes using interpolation
- Only evaluated after successful `terraform apply`

**Usage in CI/CD**:
- `cloudfront_distribution_id` → Used in GitHub Actions for cache invalidation
- `s3_bucket_name` → Used in GitHub Actions for file sync
- `website_url` → Used for deployment verification

---

## 🔢 Logic Steps - Synchronized Across Files

Each Terraform file contains numbered step comments that correspond to the logic flow. This section provides a centralized reference to ensure documentation and code remain synchronized.

### variables.tf - Variable Definitions (5 Steps)
```
STEP 1: Define AWS region variable
STEP 2: Define S3 bucket name variable
STEP 3: Define domain name variable
STEP 4: Define project name variable
STEP 5: Define environment variable
```

### terraform.tfvars - Variable Values (5 Steps)
```
STEP 1: Set AWS region value
STEP 2: Set S3 bucket name value
STEP 3: Set domain name value
STEP 4: Set project name value
STEP 5: Set environment value
```

### main.tf - Infrastructure Resources (14 Steps)
```
STEP 1:  Initialize Terraform configuration and AWS provider
STEP 2:  Create S3 bucket for static website hosting
STEP 3:  Configure S3 bucket ownership controls
STEP 4:  Configure S3 bucket public access settings
STEP 5:  Set S3 bucket ACL to public-read
STEP 6:  Enable static website hosting on S3 bucket
STEP 7:  Create S3 bucket policy for public read access
STEP 8:  Create ACM SSL certificate for domain
STEP 9:  Create Route53 hosted zone for DNS management
STEP 10: Create DNS validation records for ACM certificate
STEP 11: Validate ACM certificate via DNS
STEP 12: Create CloudFront distribution for CDN and HTTPS
STEP 13: Create Route53 A record for root domain pointing to CloudFront
STEP 14: Create Route53 A record for www subdomain pointing to CloudFront
```

### outputs.tf - Output Values (8 Steps)
```
STEP 1: Output S3 bucket name
STEP 2: Output S3 bucket website endpoint
STEP 3: Output CloudFront distribution ID (needed for CI/CD)
STEP 4: Output CloudFront distribution domain name
STEP 5: Output CloudFront hosted zone ID
STEP 6: Output ACM certificate ARN
STEP 7: Output Route53 hosted zone ID
STEP 8: Output final website URL
```

---

## 🔄 Execution Flow

### Initialization Phase
```
terraform init
    ↓
Downloads AWS provider plugin
    ↓
Initializes backend (if configured)
    ↓
Creates .terraform/ directory
```

### Planning Phase
```
terraform plan
    ↓
Reads variables.tf for definitions
    ↓
Reads terraform.tfvars for actual values
    ↓
Reads main.tf for resource definitions
    ↓
Compares current state with desired state
    ↓
Generates execution plan
```

### Apply Phase
```
terraform apply
    ↓
Creates/updates resources in order:
    1. S3 bucket and configurations
    2. Route53 hosted zone
    3. ACM certificate
    4. DNS validation records
    5. Certificate validation
    6. CloudFront distribution
    7. Route53 A records
    ↓
Evaluates outputs.tf
    ↓
Displays output values
```

### Destroy Phase
```
terraform destroy
    ↓
Destroys resources in reverse order:
    1. Route53 A records
    2. CloudFront distribution
    3. Certificate validation
    4. DNS validation records
    5. ACM certificate
    6. Route53 hosted zone
    7. S3 bucket and configurations
```

---

## 🔗 File Dependencies

```
terraform.tfvars (values)
    ↓
variables.tf (definitions)
    ↓
main.tf (resource configuration)
    ↓
outputs.tf (result display)
```

**Dependency Flow**:
1. `variables.tf` defines the contract (what variables exist)
2. `terraform.tfvars` provides the actual values
3. `main.tf` uses variables to configure resources
4. `outputs.tf` extracts and displays resource attributes

---

## 🛠️ Common Commands

```bash
# Initialize Terraform (downloads providers)
terraform init

# Preview changes without applying
terraform plan

# Apply changes with auto-approval
terraform apply -auto-approve

# Apply with specific variables file
terraform apply -var-file="custom.tfvars"

# Show current state
terraform show

# Destroy all resources
terraform destroy

# Format all Terraform files
terraform fmt

# Validate syntax
terraform validate

# Refresh state (sync with AWS)
terraform refresh
```

---

## 🔧 Configuration for Different Environments

### Development
Create `dev.tfvars`:
```hcl
aws_region   = "ap-south-1"
bucket_name  = "dev-www.sanjaydhiman.com"
domain_name  = "dev.sanjaydhiman.com"
project_name = "sanjay-dhiman-website"
environment  = "dev"
```

### Staging
Create `staging.tfvars`:
```hcl
aws_region   = "ap-south-1"
bucket_name  = "staging-www.sanjaydhiman.com"
domain_name  = "staging.sanjaydhiman.com"
project_name = "sanjay-dhiman-website"
environment  = "staging"
```

### Production
Use existing `terraform.tfvars` or create `prod.tfvars`:
```hcl
aws_region   = "ap-south-1"
bucket_name  = "www.sanjaydhiman.com"
domain_name  = "sanjaydhiman.com"
project_name = "sanjay-dhiman-website"
environment  = "prod"
```

Apply with:
```bash
terraform apply -var-file="dev.tfvars"
terraform apply -var-file="staging.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

## 📊 Resource Creation Order

Terraform automatically manages dependencies, but the logical order is:

1. **S3 Bucket** (foundation)
2. **Route53 Hosted Zone** (for DNS)
3. **ACM Certificate** (for SSL)
4. **DNS Validation Records** (to validate certificate)
5. **Certificate Validation** (waits for DNS propagation)
6. **CloudFront Distribution** (needs valid certificate)
7. **Route53 A Records** (needs CloudFront domain)

---

## 🔐 Security Considerations

- **terraform.tfvars** should be in `.gitignore`
- Use AWS IAM roles instead of access keys when possible
- Enable S3 bucket encryption (add `server_side_encryption_configuration`)
- Use Terraform workspaces for state isolation
- Enable versioning on S3 bucket
- Consider using AWS Secrets Manager for sensitive values

---

## 🚨 Troubleshooting

### State File Issues
```bash
# If state is corrupted
terraform state pull > backup.tfstate
terraform state push backup.tfstate
```

### Resource Already Exists
```bash
# Import existing resource into state
terraform import aws_s3_bucket.website_bucket www.sanjaydhiman.com
```

### Dependency Conflicts
```bash
# Refresh state to sync with actual AWS resources
terraform refresh -var-file="terraform.tfvars"
```

---

## 📝 Additional Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Configuration Syntax](https://www.terraform.io/docs/language/syntax/configuration.html)
- [Terraform State](https://www.terraform.io/docs/language/state/index.html)
