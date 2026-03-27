# Terraform AWS Production Baseline

Production-oriented Terraform/OpenTofu baseline for deploying a secure, scalable AWS foundation. This repository demonstrates a practical Infrastructure as Code approach for standing up a VPC, public/private subnets, security groups, an Application Load Balancer, and an Auto Scaling Group-backed application tier.

## Why this repository exists

This project is intended to demonstrate:

- Practical AWS Infrastructure as Code using **Terraform/OpenTofu**
- Reusable module structure
- Remote state support with S3 + DynamoDB locking
- Secure-by-default networking patterns
- Scalable application deployment baseline suitable for extension into ECS, EKS, or full CI/CD workflows

## Architecture

The baseline provisions:

- VPC with public and private subnets across multiple AZs
- Internet Gateway and route tables
- Security groups for load balancer and application tier
- Application Load Balancer
- Launch Template + Auto Scaling Group
- IAM instance profile
- Remote state backend example

## Repository structure

```text
.
├── backend.hcl.example
├── envs/
│   └── dev/
│       ├── main.tf
│       ├── terraform.tfvars.example
│       └── variables.tf
├── modules/
│   ├── alb/
│   ├── app_asg/
│   ├── network/
│   └── security/
└── versions.tf
```

## Getting started

### 1. Prerequisites

- Terraform or OpenTofu
- AWS CLI configured
- An AWS account with sufficient permissions

### 2. Configure backend

Copy the backend example and update values:

```bash
cp backend.hcl.example backend.hcl
```

### 3. Initialise

```bash
terraform init -backend-config=backend.hcl
```

### 4. Review and apply

```bash
cd envs/dev
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Design decisions

- **Private application tier**: application instances are not directly internet-exposed
- **ALB in public subnets**: standard entry point for HTTP traffic
- **ASG + Launch Template**: supports scaling and immutable-ish update patterns
- **Module separation**: enables reuse, maintainability, and clearer ownership boundaries

## Cost awareness

This baseline is intentionally designed so it can be evolved toward cost-conscious operation:

- Instance type controlled through variables
- Desired capacity configurable per environment
- Easily extended for Spot diversification
- Suitable for rightsizing, lifecycle policies, and scheduled scaling

## Suggested extensions

- Add ECS/Fargate support
- Add GitHub Actions pipeline for plan/apply
- Add tfsec or Checkov scanning
- Add CloudWatch alarms and dashboards
- Add Route53 + ACM for TLS

## Disclaimer

This is a learning and portfolio repository. Review security, networking, IAM, and cost settings before production use.
