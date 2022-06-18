resource "aws_lambda_provisioned_concurrency_config" "config" {
  for_each = {
    for config in var.provisioned_concurrency_config : join(":", [
      config.qualifier,
      config.provisioned_concurrent_executions
    ]) => config
  }

  function_name                     = aws_lambda_function.function.function_name
  qualifier                         = each.value.qualifier
  provisioned_concurrent_executions = each.value.provisioned_concurrent_executions
}
