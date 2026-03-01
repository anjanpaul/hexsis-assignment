include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/ecs"
}

# No dependency blocks at all

inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  # Manually set VPC values
  vpc_id             = "vpc-09cafbe212ff0cbcf"
  private_subnet_ids = ["subnet-07969e7e9fb8cbfc4", "subnet-0bcd4a507287ce3a4"]

  # Manually set ALB values
  alb_security_group_id = "sg-01803d296505d5aef"
  target_group_arn      = "arn:aws:elasticloadbalancing:ap-southeast-1:688567278489:targetgroup/hexsis-svc-prod-tg/0fd4c78b40058b2c"

  # ECS specific
  container_image  = "688567278489.dkr.ecr.ap-southeast-1.amazonaws.com/my-portfolio:3.0.0"
  container_port   = 80
  container_cpu    = 256
  container_memory = 512
  desired_count    = 2
}
