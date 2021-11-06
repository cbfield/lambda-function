resource "aws_iam_role" "role" {
  count = var.role == null ? 1 : 0

  name               = var.name
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
}

resource "aws_iam_role_policy" "role_policy" {
  for_each = var.role == null ? (
    { for policy in var.role_policies : policy.name => policy }
  ) : {}

  name        = each.value.name
  name_prefix = each.value.name_prefix
  policy      = each.value.policy
  role        = aws_iam_role.role.0.arn
}

resource "aws_iam_role_policy" "logging" {
  count = var.logging_enabled ? 1 : 0

  name   = "${var.name}-logging"
  role   = aws_iam_role.role.0.arn
  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": "arn:aws:logs:*:*:*",
          "Effect": "Allow"
        }
      ]
    }
    EOF
}
