module "test_users" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-user?ref=v5.3.0"

  count = var.num_users

  name = "TestUser${count.index + 1}"

  force_destroy = true

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}

module "test_group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-group-with-policies?ref=v5.3.0"

  name                     = "TestGroup"
  group_users              = module.test_users[*].iam_user_name
  custom_group_policy_arns = [aws_iam_policy.test_policy.arn]

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}

resource "aws_iam_policy" "test_policy" {
  name        = "TestPolicy"
  description = "Test policy for demo AWS environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:GetCallerIdentity"
        Resource = "*"
      },
    ]
  })

  tags = {
    Environment = var.environment
    Contact     = var.contact
  }
}
