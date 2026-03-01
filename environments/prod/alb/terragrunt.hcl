include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/alb"
}

# No dependency blocks

inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  # Manually set VPC values
  vpc_id            = "vpc-09cafbe212ff0cbcf"
  public_subnet_ids = ["subnet-0c7dcbf545cc18a82", "subnet-02eba0b0eacb867a9"]

  container_port    = 80
  health_check_path = "/"
}