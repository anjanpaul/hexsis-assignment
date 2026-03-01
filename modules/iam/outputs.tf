output "user_name" {
  value = aws_iam_user.this.name
}

output "user_arn" {
  value = aws_iam_user.this.arn
}

output "access_key_id" {
  value = var.create_access_key ? aws_iam_access_key.this[0].id : null
}

output "secret_access_key" {
  value     = var.create_access_key ? aws_iam_access_key.this[0].secret : null
  sensitive = true
}