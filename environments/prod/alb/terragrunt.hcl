include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/alb"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000"
    public_subnet_ids = ["subnet-00000000", "subnet-11111111"]
  }
}

inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  vpc_id            = dependency.vpc.outputs.vpc_id
  public_subnet_ids = dependency.vpc.outputs.public_subnet_ids

  container_port    = 80
  health_check_path = "/"
}