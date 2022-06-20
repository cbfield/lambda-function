resource "aws_api_gateway_rest_api" "api" {
  count = var.private_api_endpoint != null ? 1 : 0

  name        = var.name
  description = "HTTPS endpoint for Lambda function ${var.name}"

  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = var.private_api_endpoint.vpce_ids
  }

  tags = merge(var.private_api_endpoint.tags, {
    "Managed By Terraform" = "true"
  })
}

resource "aws_api_gateway_rest_api_policy" "private_access" {
  count = var.private_api_endpoint != null ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.0.id
  policy = templatefile("${path.module}/templates/apigw-rest-api-policy.json.tpl", {
    api_id    = aws_api_gateway_rest_api.api[0].id
    caller_id = data.aws_caller_identity.current.id
    region    = data.aws_region.current.id
    vpce_ids  = var.private_api_endpoint.vpce_ids
  })
}

resource "aws_api_gateway_method" "invoke" {
  count = var.private_api_endpoint != null ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api[0].id
  resource_id   = aws_api_gateway_rest_api.api[0].root_resource_id
  http_method   = "ANY"
  authorization = coalesce(var.private_api_endpoint.authorization, "NONE")
}

resource "aws_api_gateway_integration" "lambda" {
  count = var.private_api_endpoint != null ? 1 : 0

  rest_api_id             = aws_api_gateway_rest_api.api[0].id
  resource_id             = aws_api_gateway_rest_api.api[0].root_resource_id
  http_method             = aws_api_gateway_method.invoke[0].http_method
  integration_http_method = aws_api_gateway_method.invoke[0].http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.function.arn}:$${stageVariables.env}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  for_each = var.private_api_endpoint != null ? coalesce(
    var.private_api_endpoint.qualifiers,
    [for alias in var.aliases : alias.name]
  ) : toset([])

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  qualifier     = each.key
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:${aws_api_gateway_rest_api.api[0].id}/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  count = var.private_api_endpoint != null ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api[0].id

  depends_on = [
    aws_api_gateway_rest_api.api[0],
    aws_api_gateway_method.invoke[0],
    aws_api_gateway_integration.lambda[0]
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  for_each = var.private_api_endpoint != null ? coalesce(
    var.private_api_endpoint.qualifiers,
    [for alias in var.aliases : alias.name]
  ) : toset([])

  rest_api_id   = aws_api_gateway_rest_api.api[0].id
  stage_name    = each.key
  deployment_id = aws_api_gateway_deployment.deployment[0].id
  variables     = { env = each.key }

  tags = merge(var.private_api_endpoint.tags, {
    "Managed By Terraform" = "true"
  })
}
