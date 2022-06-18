resource "aws_lambda_function_url" "url" {
  for_each = {
    for url in var.function_urls : coalesce(
      url.qualifier,
      "all-qualifiers"
    ) => url
  }

  authorization_type = each.value.authorization_type
  function_name      = aws_lambda_function.function.function_name
  qualifier          = each.value.qualifier

  dynamic "cors" {
    for_each = each.value.cors != null ? [1] : []
    content {
      allow_credentials = cors.value.allow_credentials
      allow_headers     = cors.value.allow_headers
      allow_methods     = cors.value.allow_methods
      allow_origins     = cors.value.allow_origins
      expose_headers    = cors.value.expose_headers
      max_age           = cors.value.max_age
    }
  }
}
