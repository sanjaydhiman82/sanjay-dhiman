# 🚀 GitHub Actions Workflow - Deploy Static Website to AWS

This directory contains the GitHub Actions workflow that automates the deployment of the static website to AWS S3 and CloudFront CDN.

## 📄 File Structure

```
.github/workflows/
├── deploy.yml           # Main deployment workflow
└── README.md            # This documentation file
```

---

## 📋 Workflow Overview

**File**: `deploy.yml`

**Purpose**: Automates the deployment process by syncing website files to S3 and invalidating the CloudFront cache on every push to the `main` branch.

**Deployment Flow**:
```
Git Push to main
    ↓
Checkout Code
    ↓
Configure AWS Credentials
    ↓
Sync Files to S3
    ↓
Invalidate CloudFront Cache
    ↓
Deployment Complete
```

---

## ✅ GitHub Setup Checklist - REQUIRED CHANGES

Before this workflow will work, you MUST complete these steps in your GitHub repository:

### Step 1: Configure GitHub Secrets

Navigate to: **GitHub Repository → Settings → Secrets and variables → Actions**

Add these **Repository Secrets**:

| Secret Name | Value Source | How to Get It |
|-------------|--------------|---------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM Console | Create IAM user → Security credentials → Create access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM Console | Generated when creating access key (save immediately!) |
| `CLOUDFRONT_DISTRIBUTION_ID` | Terraform Output | Run `terraform apply` → copy `cloudfront_distribution_id` |
| `BUCKET_NAME` (optional) | Terraform Output | Run `terraform apply` → copy `s3_bucket_name` (or use fallback) |

**Detailed Steps:**
```
1. Go to your GitHub repository page
2. Click "Settings" tab (top navigation)
3. In left sidebar, click "Secrets and variables"
4. Click "Actions" submenu
5. Click "New repository secret" button
6. Add AWS_ACCESS_KEY_ID:
   - Name: AWS_ACCESS_KEY_ID
   - Value: AKIA... (your IAM access key)
7. Click "Add secret"
8. Repeat for AWS_SECRET_ACCESS_KEY
9. Repeat for CLOUDFRONT_DISTRIBUTION_ID (from Terraform output)
10. (Optional) Add BUCKET_NAME secret
```

---

### Step 2: Create AWS IAM User for GitHub Actions

**In AWS Console:**
```
1. Go to AWS IAM Console
2. Click "Users" in left sidebar
3. Click "Add users"
4. User name: github-actions-deploy
5. Access type: Access key - Programmatic access
6. Click "Next: Permissions"
7. Click "Attach existing policies directly"
8. Create inline policy with this JSON:
```

**IAM Policy (Minimal Permissions):**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3WebsiteDeploy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::www.sanjaydhiman.com",
        "arn:aws:s3:::www.sanjaydhiman.com/*"
      ]
    },
    {
      "Sid": "CloudFrontInvalidation",
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

**Complete IAM Setup:**
```
9. Attach the custom policy to your IAM user
10. Click "Next: Tags" (skip or add tags)
11. Click "Next: Review"
12. Click "Create user"
13. IMPORTANT: Copy Access key ID and Secret access key NOW
    - You cannot see the secret key again after closing this dialog
14. Save these for GitHub secrets (Step 1)
```

---

### Step 3: Run Terraform to Create Infrastructure

**In your terminal:**
```bash
# Navigate to terraform directory
cd terraform/

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Apply infrastructure (creates S3, CloudFront, Route53, ACM)
terraform apply

# When prompted, type "yes"

# After completion, copy these outputs for GitHub secrets:
# - cloudfront_distribution_id
# - s3_bucket_name (optional)
```

**Expected Terraform Outputs:**
```
cloudfront_distribution_id = "E1B2C3D4E5F6G7"
s3_bucket_name = "www.sanjaydhiman.com"
website_url = "https://www.sanjaydhiman.com"
```

---

### Step 4: Verify Repository Structure

**Your repository should have this structure:**
```
sanjay-dhiman/
├── website/                    # REQUIRED: Website files go here
│   ├── index.html
│   └── ... (your static files)
├── .github/
│   └── workflows/
│       ├── deploy.yml         # This workflow file
│       └── README.md          # This documentation
└── terraform/                 # Infrastructure code
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars
```

**CRITICAL:** Create the `website/` directory and add your files:
```bash
mkdir website
cp -r your-website-files/* website/
git add website/
git commit -m "Add website files"
git push origin main
```

---

### Step 5: Test the Workflow

**Trigger deployment:**
```bash
# Make any change to website files
echo "Test deployment" >> website/index.html

# Commit and push
git add .
git commit -m "Test deployment workflow"
git push origin main
```

**Verify in GitHub:**
```
1. Go to GitHub repository
2. Click "Actions" tab
3. Look for "Deploy Static Website to AWS" workflow
4. Click on the latest run
5. Check each step for green checkmarks ✅
6. Wait for "Deployment Summary" step
```

---

### Step 6: Configure Branch Protection (Optional but Recommended)

**Prevent direct pushes to main, require reviews:**
```
1. GitHub Repository → Settings
2. Click "Branches" in left sidebar
3. Click "Add rule" button
4. Branch name pattern: main
5. Check these options:
   ✅ Require a pull request before merging
   ✅ Require status checks to pass before merging
   ✅ Require branches to be up to date before merging
   ✅ Include administrators
6. Click "Create"
```

---

## 📋 Pre-Deployment Checklist

Before your first deployment, verify:

- [ ] **AWS IAM User** created with correct permissions
- [ ] **AWS Access Keys** generated and saved
- [ ] **GitHub Secrets** configured (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, CLOUDFRONT_DISTRIBUTION_ID)
- [ ] **Terraform Applied** - Infrastructure exists in AWS
- [ ] **S3 Bucket** created and accessible
- [ ] **CloudFront Distribution** deployed (can take 15-30 min)
- [ ] **website/** directory exists in repository root
- [ ] **index.html** exists in website/ directory
- [ ] **GitHub Actions** tab shows workflow is enabled

---

## 🔧 Workflow Configuration

### 1. Workflow Name
```yaml
name: Deploy Static Website to AWS
```
**Purpose**: Display name shown in GitHub Actions UI and status checks.

---

### 2. Triggers (on:)
```yaml
on:
  push:
    branches:
      - main
  workflow_dispatch:
```

**Logic Steps**:
- **STEP 1**: Trigger on push to `main` branch
  - Automatically deploys when code is pushed/merged to main
- **STEP 2**: Enable manual trigger via `workflow_dispatch`
  - Allows manual execution from GitHub Actions tab
  - Useful for testing or emergency deployments

---

### 3. Environment Variables (env:)
```yaml
env:
  AWS_REGION: ap-south-1
  BUCKET_NAME: ${{ secrets.BUCKET_NAME || 'www.sanjaydhiman.com' }}
  CLOUDFRONT_DISTRIBUTION_ID: ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}
```

**Logic Steps**:

| Variable | Value | Description | Step |
|----------|-------|-------------|------|
| `AWS_REGION` | `ap-south-1` | AWS Mumbai region for all operations | STEP 3 |
| `BUCKET_NAME` | `${{ secrets.BUCKET_NAME \|\| 'www.sanjaydhiman.com' }}` | S3 bucket name (reads from secrets or uses fallback) | STEP 4 |
| `CLOUDFRONT_DISTRIBUTION_ID` | `${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }}` | CloudFront distribution ID for cache invalidation | STEP 5 |

**Logic Flow**:
```
STEP 3: Initialize AWS_REGION
    ↓
STEP 4: Initialize BUCKET_NAME (check secrets → fallback to default)
    ↓
STEP 5: Initialize CLOUDFRONT_DISTRIBUTION_ID (must be set in secrets)
```

---

### 4. Jobs Configuration (jobs:)

#### Job: `deploy`
```yaml
jobs:
  deploy:
    name: Deploy to S3 and Invalidate CloudFront
    runs-on: ubuntu-latest
```

**Logic Steps**:
- **STEP 6**: Define job name for GitHub Actions UI display
- **STEP 7**: Specify runner environment (`ubuntu-latest`)

**Runner Details**:
- **OS**: Ubuntu 22.04 LTS (latest)
- **Pre-installed**: AWS CLI v2, Git, Python, Node.js
- **Architecture**: x64

---

### 5. Steps Breakdown

#### STEP 8: Checkout Repository
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```

**Purpose**: Clone the repository code into the runner environment.

**Logic**:
```
Fetch repository code
    ↓
Checkout latest commit from triggering branch
    ↓
Files available at ./ (root of workspace)
```

**Dependencies**:
- Requires: None (first step)
- Provides: Source code for subsequent steps

---

#### STEP 9: Configure AWS Credentials
```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: ${{ env.AWS_REGION }}
```

**Purpose**: Authenticate with AWS using IAM credentials stored in GitHub secrets.

**Logic**:
```
Read AWS_ACCESS_KEY_ID from secrets
    ↓
Read AWS_SECRET_ACCESS_KEY from secrets
    ↓
Set AWS_REGION from environment variable
    ↓
Configure AWS CLI with credentials
    ↓
AWS CLI ready for subsequent commands
```

**Action Details**:
- **Action**: `aws-actions/configure-aws-credentials@v4`
- **Inputs**:
  - `aws-access-key-id`: IAM user access key ID
  - `aws-secret-access-key`: IAM user secret access key
  - `aws-region`: Target AWS region
- **Outputs**: Configured AWS CLI session

**Required IAM Permissions**:
- `s3:PutObject` - Upload files to S3
- `s3:GetObject` - Read files from S3
- `s3:DeleteObject` - Remove files from S3
- `s3:ListBucket` - List bucket contents
- `cloudfront:CreateInvalidation` - Create cache invalidation
- `cloudfront:GetInvalidation` - Check invalidation status

---

#### STEP 10: Sync Files to S3
```yaml
- name: Sync files to S3
  run: |
    aws s3 sync ./website/ s3://${{ env.BUCKET_NAME }} --delete --cache-control "public, max-age=31536000, immutable"
```

**Purpose**: Upload website files from local `./website/` directory to S3 bucket.

**Logic**:
```
Identify source directory: ./website/
    ↓
Identify target bucket: s3://${{ env.BUCKET_NAME }}
    ↓
Compare local files with S3 bucket contents
    ↓
Upload new/modified files to S3
    ↓
Delete files from S3 that don't exist locally (--delete flag)
    ↓
Apply cache-control headers to all files
    ↓
Sync complete
```

**Command Breakdown**:
- `aws s3 sync`: Synchronize directories
- `./website/`: Local source directory containing website files
- `s3://${{ env.BUCKET_NAME }}`: Target S3 bucket
- `--delete`: Remove files from S3 that don't exist in source
- `--cache-control "public, max-age=31536000, immutable"`: Set HTTP cache headers
  - `public`: Response may be cached by any cache
  - `max-age=31536000`: Cache for 1 year (in seconds)
  - `immutable`: Indicates the response body will not change over time

**Dependencies**:
- Requires: STEP 8 (code checked out), STEP 9 (AWS credentials configured)
- Provides: Website files uploaded to S3

---

#### STEP 11: Invalidate CloudFront Cache
```yaml
- name: Invalidate CloudFront cache
  run: |
    aws cloudfront create-invalidation \
      --distribution-id ${{ env.CLOUDFRONT_DISTRIBUTION_ID }} \
      --paths "/*"
```

**Purpose**: Clear the CloudFront CDN cache to ensure new files are served immediately.

**Logic**:
```
Identify CloudFront distribution ID
    ↓
Create invalidation request for all paths (/*)
    ↓
CloudFront propagates invalidation to all edge locations
    ↓
Cache cleared - visitors receive fresh content
```

**Command Breakdown**:
- `aws cloudfront create-invalidation`: Create a cache invalidation
- `--distribution-id`: Target CloudFront distribution
- `--paths "/*"`: Invalidate all files (can specify specific paths like `/index.html`)

**Why Invalidate?**
- CloudFront caches files at edge locations for performance
- Without invalidation, old cached versions may be served to users
- Invalidation forces CloudFront to fetch fresh content from S3

**Note**: CloudFront invalidations can take 5-30 minutes to propagate globally.

**Dependencies**:
- Requires: STEP 10 (files synced to S3)
- Provides: Fresh content delivery enabled

---

#### STEP 12: Deployment Summary
```yaml
- name: Deployment Summary
  run: |
    echo "✅ Deployment successful!"
    echo "📦 S3 Bucket: ${{ env.BUCKET_NAME }}"
    echo "🌐 CloudFront Distribution: ${{ env.CLOUDFRONT_DISTRIBUTION_ID }}"
```

**Purpose**: Display deployment summary in GitHub Actions logs for verification.

**Output**:
```
✅ Deployment successful!
📦 S3 Bucket: www.sanjaydhiman.com
🌐 CloudFront Distribution: E1234567890ABC
```

**Dependencies**:
- Requires: STEP 11 (invalidation created)
- Provides: Deployment confirmation in logs

---

## 🔐 Required GitHub Secrets

Navigate to: **GitHub Repository → Settings → Secrets and variables → Actions**

Add these secrets:

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `AWS_ACCESS_KEY_ID` | IAM user access key ID | ✅ Yes |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret access key | ✅ Yes |
| `BUCKET_NAME` | S3 bucket name (optional, fallback in workflow) | ❌ No |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID | ✅ Yes |

**Setting Up Secrets**:

```bash
# 1. Go to GitHub Repository
# 2. Click Settings tab
# 3. Click Secrets and variables → Actions
# 4. Click New repository secret
# 5. Add each secret name and value
```

**Getting Values from Terraform Outputs**:

After running `terraform apply`, use these outputs:
- `s3_bucket_name` → `BUCKET_NAME` secret
- `cloudfront_distribution_id` → `CLOUDFRONT_DISTRIBUTION_ID` secret

---

## 📊 Complete Execution Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        TRIGGER                                  │
│         Push to main branch  OR  Manual trigger                 │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 1: Workflow triggered                                     │
│  - Check event type (push or workflow_dispatch)                 │
│  - Load environment variables                                   │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 2: Initialize job                                         │
│  - Start ubuntu-latest runner                                   │
│  - Set up execution environment                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 3: Checkout Code                                          │
│  - Clone repository to runner                                   │
│  - Files available at ./website/                                │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 4: Configure AWS Credentials                            │
│  - Read secrets (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)      │
│  - Configure AWS CLI                                            │
│  - Set region to ap-south-1                                     │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 5: Sync to S3                                             │
│  - Upload ./website/ to s3://www.sanjaydhiman.com               │
│  - Delete files not in local directory                          │
│  - Apply cache-control headers                                  │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 6: Invalidate CloudFront                                  │
│  - Create invalidation for all paths (/*)                       │
│  - Distribution ID from secrets                                 │
└───────────────────────────┬─────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│  STEP 7: Deployment Summary                                     │
│  - Log success message                                          │
│  - Display bucket and distribution info                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Customization

### Change Deployment Branch
```yaml
on:
  push:
    branches:
      - main        # Change to your default branch
      - production  # Or add multiple branches
```

### Add Multiple Environments
```yaml
jobs:
  deploy-staging:
    if: github.ref == 'refs/heads/staging'
    # ... staging config
  
  deploy-production:
    if: github.ref == 'refs/heads/main'
    # ... production config
```

### Exclude Files from Sync
```yaml
- name: Sync files to S3
  run: |
    aws s3 sync ./website/ s3://${{ env.BUCKET_NAME }} \
      --delete \
      --cache-control "public, max-age=31536000, immutable" \
      --exclude "*.tmp" \
      --exclude "drafts/*"
```

### Invalidate Specific Paths Only
```yaml
- name: Invalidate CloudFront cache
  run: |
    aws cloudfront create-invalidation \
      --distribution-id ${{ env.CLOUDFRONT_DISTRIBUTION_ID }} \
      --paths "/index.html" "/css/*" "/js/*"
```

### Add Deployment Notifications
```yaml
- name: Notify Slack
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "Deployment complete: ${{ env.BUCKET_NAME }}"
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

---

## 🐛 Troubleshooting

### Workflow Not Triggering
- **Cause**: Push to wrong branch
- **Solution**: Ensure pushing to `main` branch

### AWS Credentials Error
```
Error: Could not load credentials from any providers
```
- **Cause**: Secrets not configured
- **Solution**: Add `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to GitHub secrets

### S3 Sync Fails
```
Error: An error occurred (AccessDenied) when calling the PutObject operation
```
- **Cause**: IAM user lacks S3 permissions
- **Solution**: Add `s3:PutObject`, `s3:DeleteObject`, `s3:ListBucket` to IAM policy

### CloudFront Invalidation Fails
```
Error: An error occurred (AccessDenied) when calling the CreateInvalidation operation
```
- **Cause**: IAM user lacks CloudFront permissions
- **Solution**: Add `cloudfront:CreateInvalidation` to IAM policy

### Bucket Name Not Found
```
Error: The specified bucket does not exist
```
- **Cause**: Terraform not applied or wrong bucket name
- **Solution**: Run `terraform apply` first, then verify bucket name in secrets

### CloudFront Distribution Not Found
```
Error: No such distribution
```
- **Cause**: Wrong distribution ID or Terraform not applied
- **Solution**: Verify distribution ID from Terraform outputs

---

## 📚 References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS CLI Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html)
- [aws-actions/configure-aws-credentials](https://github.com/aws-actions/configure-aws-credentials)
- [actions/checkout](https://github.com/actions/checkout)
- [S3 Sync Documentation](https://docs.aws.amazon.com/cli/latest/reference/s3/sync.html)
- [CloudFront Invalidation](https://docs.aws.amazon.com/cli/latest/reference/cloudfront/create-invalidation.html)

---

## 📝 Version History

- **v1.0** - Initial workflow setup
  - S3 sync with cache headers
  - CloudFront invalidation
  - Manual trigger support
