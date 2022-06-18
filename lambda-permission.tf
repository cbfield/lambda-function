resource "aws_lambda_permission" "permissions" {
  for_each = {
    for permission in var.permissions : join("_", [
      permission.source_arn,
      permission.action,
      permission.qualifier
    ]) => permission
  }

  action                 = each.value.action
  event_source_token     = each.value.event_source_token
  fuction_name           = aws_lambda_function.function.function_name
  function_url_auth_type = each.value.function_url_auth_type
  principal              = each.value.principal
  principal_org_id       = each.value.principal_org_id
  qualifier              = each.value.qualifier
  source_account         = each.value.source_account
  source_arn             = each.value.source_arn
  statement_id           = each.value.statement_id
  statement_id_prefix    = each.value.statement_id_prefix
}
