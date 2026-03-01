# Hexsis Application Infrastructure

Infrastructure as Code using **Terraform** and **Terragrunt** to deploy a containerized application on AWS ECS Fargate.

## Architecture

```
Internet → ALB (HTTPS/HTTP) → ECS Fargate (Private Subnets) → ECR (Container Images)
```

### AWS Resources

| Module | Description |
|--------|-------------|
| **VPC** | VPC, public/private subnets, NAT gateway, route tables |
| **ALB** | Application Load Balancer, target group, HTTP/HTTPS listeners |
| **ECS** | ECS cluster, Fargate service, task definition, security groups, IAM roles |
| **ECR** | Elastic Container Registry for Docker images |
| **IAM** | CI/CD user with minimum permissions for GitHub Actions |

---

## Project Structure

```
❯ tree
.
├── environments
│   └── prod
│       ├── alb
│       │   └── terragrunt.hcl
│       ├── ecr
│       │   └── terragrunt.hcl
│       ├── ecs
│       │   └── terragrunt.hcl
│       ├── env.hcl
│       ├── iam
│       │   └── ecs-cicd-user
│       │       └── terragrunt.hcl
│       └── vpc
│           └── terragrunt.hcl
├── modules
│   ├── alb
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ecr
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ecs
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── readme.md
└── terragrunt.hcl

14 directories, 23 files                 
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) (>= 1.5)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) (>= 0.50)

---

## Getting Started

### 1. Clone the Repository

```bash
git clone git@github.com:anjanpaul/hexsis-assignment.git
cd hexsis-assignment
```

### 2. Configure Environment Variables

Review and update `environments/prod/env.hcl` with your environment-specific values:

```hcl
locals {
  aws_region   = "ap-southeast-1"
  project_name = "hexsis-svc"
  environment  = "prod"
}
```

---

## Deployment Guide

> **Important:** Deploy modules in the following order. Each module depends on the previous one.

### Step 1: Deploy VPC

Creates the VPC, subnets, NAT gateway, and route tables.

```bash
cd environments/prod/vpc
terragrunt plan      
terragrunt apply    
```

Verify outputs:

```bash
terragrunt output
```

Expected outputs: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`

---

### Step 2: Deploy ALB

Creates the Application Load Balancer, target group, and listeners.

```bash
cd environments/prod/alb
terragrunt plan
terragrunt apply
```

Verify outputs:

```bash
terragrunt output
```

Expected outputs: `alb_dns_name`, `target_group_arn`, `alb_security_group_id`

---

### Step 3: Deploy ECR

Creates the container registry to store Docker images.

```bash
cd environments/prod/ecr
terragrunt plan
terragrunt apply
```

Verify outputs:

```bash
terragrunt output
```

Expected outputs: `repository_url`, `repository_name`

---

---

### Step 4: Deploy ECS

Creates the ECS cluster, Fargate service, and task definition.

> **Before deploying:** Update `container_image` in `environments/prod/ecs/terragrunt.hcl` with your ECR image URL.

```bash
cd environments/prod/ecs
terragrunt plan
terragrunt apply
```

Verify outputs:

```bash
terragrunt output
```

Expected outputs: `cluster_name`, `service_name`

Verify the service is running:

```bash
aws ecs describe-services \
  --cluster hexsis-svc-prod-cluster \
  --services hexsis-svc-prod-service \
  --query 'services[0].runningCount'
```

---

### Step 6: Deploy IAM (CI/CD User)

Creates a minimal-permission IAM user for GitHub Actions deployments.

```bash
cd environments/prod/iam/ecs-cicd-user
terragrunt plan
terragrunt apply
```

Get the credentials:

```bash
terragrunt output access_key_id
terragrunt show -json
```

---

> **Warning:** Destroy in reverse order.

```bash
cd environments/prod/iam/ecs-cicd-user && terragrunt destroy
cd environments/prod/ecs && terragrunt destroy
cd environments/prod/ecr && terragrunt destroy
cd environments/prod/alb && terragrunt destroy
cd environments/prod/vpc && terragrunt destroy
```

---
