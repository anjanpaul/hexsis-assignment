variable "project_name" {}
variable "environment" {}

variable "vpc_id" {
  description = "VPC where ECS will run"
}

variable "subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups already created"
  type        = list(string)
}

variable "container_name" {}
variable "container_image" {}
variable "container_port" {
  default = 8080
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "desired_count" {
  default = 1
}