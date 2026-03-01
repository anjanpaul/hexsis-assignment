include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/ecr"
}

inputs = {
  aws_region      = local.env.locals.aws_region
  repository_name = "my-portfolio"   
  project_name    = local.env.locals.project_name  
  environment     = local.env.locals.environment  

  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  max_image_count      = 10
}