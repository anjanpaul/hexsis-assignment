resource "aws_iam_user" "this" {
  name = var.username

  tags = {
    Name        = var.username
    Environment = var.environment
  }
}

resource "aws_iam_user_policy" "this" {
  for_each = var.policies

  name   = each.key
  user   = aws_iam_user.this.name
  policy = each.value
}

resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.this.name
}