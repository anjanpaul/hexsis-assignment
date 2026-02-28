# Include root terragrunt.hcl (provider, backend, etc.)
include "root" {
  path = find_in_parent_folders()
}

# Load environment-level common variables
locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# Point to the reusable VPC module
terraform {
  source = "../../../modules/vpc"
}

# Pass inputs to the module
inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
}
