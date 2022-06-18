resource "aws_lambda_function_event_invoke_config" "invoke_config" {
  for_each = {
    for invoke_config in var.event_invoke_config : join(
      ":",
      [
        coalesce(invoke_config.maximum_event_age_in_seconds, "null"),
        coalesce(invoke_config.maximum_retry_attempts, "null"),
        coalesce(invoke_config.qualifier, "null"),
        invoke_config.destination_config == null ? "null" : join("|", [
          join(",", coalesce(destination_config.on_success, [])),
          join(",", coalesce(destination_config.on_failure, []))
        ])
      ]
    ) => invoke_config
  }

  function_name                = aws_lambda_function.function.function_name
  maximum_event_age_in_seconds = each.value.maximum_event_age_in_seconds
  maximum_retry_attempts       = each.value.maximum_retry_attempts
  qualifier                    = each.value.qualifier

  dynamic "destination_config" {
    for_each = { for conf in coalesce(each.value.destination_config, []) : join(":", [
      join(",", coalesce(destination_config.value.on_success, [])),
      join(",", coalesce(destination_config.value.on_failure, []))
      ]) => conf
    }

    content {
      dynamic "on_success" {
        for_each = coalesce(destination_config.value.on_success, [])
        content {
          destination = on_success.key
        }
      }

      dynamic "on_failure" {
        for_each = coalesce(destination_config.value.on_failure, [])
        content {
          destination = on_failure.key
        }
      }
    }
  }
}
