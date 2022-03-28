#################################################
# AWS IAM - Identity & Access Management
#
# This uses the role id (name) from the module
# to attach AmazonDynamoDBFullAccess policy,
# allowing the lambdas to access the data store.
#################################################

resource "aws_iam_role_policy_attachment" "app_data" {
  role       = module.lambda_api.lambda_exec_role_id
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy" "billing_policy" {
  name_prefix = local.roles.billing_access
  role        = module.lambda_api.lambda_exec_role_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "budget:*",
          "ce:*",
          "cur:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
