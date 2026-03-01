variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "username" {
  type = string
}

variable "policies" {
  type = map(string)
  description = "Map of policy name to policy JSON"
}

variable "create_access_key" {
  type    = bool
  default = true
}