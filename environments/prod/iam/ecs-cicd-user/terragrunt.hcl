include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  ecr_repo_arn    = "arn:aws:ecr:ap-southeast-1:688567278489:repository/my-portfolio"
  ecs_cluster_arn = "arn:aws:ecs:ap-southeast-1:688567278489:cluster/hexsis-svc-prod-cluster"
  ecs_service_arn = "arn:aws:ecs:ap-southeast-1:688567278489:service/hexsis-svc-prod-cluster/hexsis-svc-prod-service"
}

terraform {
  source = "../../../../modules/iam"
}

inputs = {
  aws_region   = local.env.locals.aws_region
  project_name = local.env.locals.project_name
  environment  = local.env.locals.environment

  username          = "github-actions-deployer"
  create_access_key = true

  policies = {
    ecr-push = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid      = "ECRAuth"
          Effect   = "Allow"
          Action   = ["ecr:GetAuthorizationToken"]
          Resource = "*"
        },
        {
          Sid    = "ECRPush"
          Effect = "Allow"
          Action = [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload"
          ]
          Resource = local.ecr_repo_arn
        }
      ]
    })

    ecs-deploy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "ECSUpdate"
          Effect = "Allow"
          Action = [
            "ecs:UpdateService",
            "ecs:DescribeServices",
            "ecs:DescribeTasks",
            "ecs:ListTasks",
            "ecs:DescribeClusters"
          ]
          Resource = [
            local.ecs_cluster_arn,
            local.ecs_service_arn
          ]
        },
        {
          Sid      = "ECSTaskDef"
          Effect   = "Allow"
          Action = [
            "ecs:DescribeTaskDefinition",
            "ecs:RegisterTaskDefinition"  
          ]
          Resource = "*"
        },
        {
          Sid    = "PassRole"
          Effect = "Allow"
          Action = [
            "iam:PassRole"
          ]
          Resource = [
            "arn:aws:iam::688567278489:role/hexsis-svc-prod-ecs-exec-role",
            "arn:aws:iam::688567278489:role/hexsis-svc-prod-ecs-task-role"
          ]
        }
      ]
    })
  }
}