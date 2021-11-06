resource "aws_cloudwatch_log_group" "logs" {
  count = var.logging_enabled ? 1 : 0

  name              = "/aws/lambda/${var.name}"
  retention_in_days = 7
}
