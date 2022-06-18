resource "aws_lambda_event_source_mapping" "mapping" {
  for_each = {
    for source_map in var.event_source_mappings : coalesce(
      source_map.event_source_arn,
      join(",", [
        for k, v in coalesce(
          try(source_map.self_managed_event_source.endpoints, null), {}
        ) : join(":", [k, v])
      ])
    ) => source_map
  }

  batch_size                         = each.value.batch_size
  bisect_batch_on_function_error     = each.value.bisect_batch_on_function_error
  enabled                            = each.value.enabled
  event_source_arn                   = each.value.event_source_arn
  function_name                      = aws_lambda_function.function.function_name
  function_response_types            = each.value.function_response_types
  maximum_batching_window_in_seconds = each.value.maximum_batching_window_in_seconds
  maximum_record_age_in_seconds      = each.value.maximum_record_age_in_seconds
  maximum_retry_attempts             = each.value.maximum_retry_attempts
  parallelization_factor             = each.value.parallelization_factor
  queues                             = each.value.queues
  starting_position                  = each.value.starting_position
  starting_position_timestamp        = each.value.starting_position_timestamp
  topics                             = each.value.topics
  tumbling_window_in_seconds         = each.value.tumbling_window_in_seconds

  dynamic "destination_config" {
    for_each = { for config in coalesce(each.value.destination_configs, []) : config.on_failure => config }
    content {
      dynamic "on_failure" {
        for_each = { for failure in try(destination_config.on_failure, []) : failure.destination_arn => failure }
        content {
          destination_arn = on_failure.value.destination_arn
        }
      }
    }
  }

  dynamic "self_managed_event_source" {
    for_each = each.value.self_managed_event_source != null ? toset([1]) : toset([])
    content {
      endpoints = each.value.self_managed_event_source.endpoints
    }
  }

  dynamic "source_access_configuration" {
    for_each = coalesce(each.value.source_access_configurations, [])
    content {
      type = source_access_configuration.value.type
      uri  = source_access_configuration.value.uri
    }
  }
}
