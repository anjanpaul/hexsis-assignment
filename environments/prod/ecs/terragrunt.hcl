include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/ecs"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000"
    private_subnet_ids = ["subnet-00000000", "subnet-11111111"]
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    target_group_arn      = "arn:aws:elasticloadbalancing:ap-southeast-1:000000000000:targetgroup/mock/000000000000"
    alb_security_group_id = "sg-00000000"
  }
}

inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  alb_security_group_id = dependency.alb.outputs.alb_security_group_id
  target_group_arn      = dependency.alb.outputs.target_group_arn

  container_image  = "688567278489.dkr.ecr.ap-southeast-1.amazonaws.com/my-portfolio:latest"
  container_port   = 80
  container_cpu    = 256
  container_memory = 512
  desired_count    = 3
}