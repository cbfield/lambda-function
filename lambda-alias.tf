resource "aws_lambda_alias" "alias" {
  for_each = { for alias in var.aliases : alias.name => alias }

  name             = each.value.name
  description      = each.value.description
  function_name    = aws_lambda_function.function.function_name
  function_version = "$LATEST"

  lifecycle {
    ignore_changes = [
      function_version,
      routing_config,
    ]
  }
}
