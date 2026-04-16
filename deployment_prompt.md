# 🚀 Production-Grade Static Website Deployment (AWS + Terraform + CI/CD)

## 🎯 Objective
Build a fully automated deployment system:

Code → Git → CI/CD → AWS → Live Website

---

## 🧠 MASTER PROMPT

Act as a senior DevOps and Cloud Architect.
input: S3 bucket name: www.sanjaydhiman.com
       domain name: www.sanjaydhiman.com
       aws region : ap-south-1 
Goal:
Build a production-grade static website hosting system using AWS S3, CloudFront, Terraform, and GitHub Actions.

Requirements:
1. Infrastructure as Code using Terraform
2. S3 bucket for static website hosting
3. CloudFront distribution for CDN and HTTPS
4. SSL certificate using AWS ACM
5. Support custom domain (root + www)
6. CI/CD pipeline using GitHub Actions
7. Automatic deployment on git push
8. CloudFront cache invalidation after deploy
9. Secure AWS access using GitHub secrets
10. Low-cost and scalable architecture

Steps:

Step 1: Create Terraform scripts
Step 2: Apply Terraform
Step 3: Configure DNS
Step 4: Setup GitHub repository
Step 5: Configure GitHub secrets
Step 6: Create CI/CD pipeline
Step 7: Push code → Auto deploy

---

## 📁 PROJECT STRUCTURE

my-project/
│── website/
│── terraform/
│── .github/workflows/

---

## ⚙️ CI/CD FLOW

On Git Push →
  Checkout Code →
  Authenticate AWS →
  Sync Files to S3 →
  Invalidate CloudFront →
  Website Live

---

## 🔐 REQUIRED PERMISSIONS

- S3 Full Access
- CloudFront Invalidation

---

## 🚀 COMMANDS

terraform init
terraform apply

git add .
git commit -m "deploy"
git push origin main

---

## 🌐 DNS CONFIG

A Record:
@ → CloudFront

CNAME:
www → CloudFront

---

## 🧠 SUMMARY

Fully automated static website deployment using AWS + Terraform + CI/CD
