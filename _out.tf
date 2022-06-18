output "aliases" {
  description = "Aliases used by the function"
  value       = aws_lambda_alias.alias
}

output "architectures" {
  description = "The value provided for var.architectures"
  value       = var.architectures
}

output "code_signing_config" {
  description = "The code signing configuration created for the function"
  value       = one(aws_lambda_code_signing_config.config)
}

output "dead_letter_config" {
  description = "The value provided for var.dead_letter_config"
  value       = var.dead_letter_config
}

output "description" {
  description = "The value provided for var.description"
  value       = var.description
}

output "environment" {
  description = "The value provided for var.environment"
  value       = var.environment
}

output "event_invoke_config" {
  description = "The value provided for var.event_invoke_config"
  value       = var.event_invoke_config
}

output "event_source_mappings" {
  description = "Event source mappings used by the function"
  value       = aws_lambda_event_source_mapping.mapping
}

output "file_system_config" {
  description = "The value provided for var.file_system_config"
  value       = var.file_system_config
}

output "filename" {
  description = "The value provided for var.filename"
  value       = var.filename
}

output "function" {
  description = "The lambda function itself"
  value       = aws_lambda_function.function
}

output "function_urls" {
  description = "Function URLs created for the function"
  value       = aws_lambda_function_url.url
}

output "handler" {
  description = "The value provided for var.handler"
  value       = var.handler
}

output "image_config" {
  description = "The value provided for var.image_config"
  value       = var.image_config
}

output "image_uri" {
  description = "The value provided for var.image_uri"
  value       = var.image_uri
}

output "kms_key_arn" {
  description = "The value provided for var.kms_key_arn"
  value       = var.kms_key_arn
}

output "layers" {
  description = "The value provided for var.layers"
  value       = var.layers
}

output "log_group" {
  description = "The Cloudwatch log group used by the function, if enabled"
  value       = one(aws_cloudwatch_log_group.logs)
}

output "logging_enabled" {
  description = "The value provided for var.logging_enabled"
  value       = var.logging_enabled
}

output "memory_size" {
  description = "The value provided for var.memory_size"
  value       = var.memory_size
}

output "name" {
  description = "The value provided for var.name"
  value       = var.name
}

output "package_type" {
  description = "The value provided for var.package_type"
  value       = var.package_type
}

output "provisioned_concurrency_config" {
  description = "The value provided for var.provisioned_concurrency_config"
  value       = var.provisioned_concurrency_config
}

output "publish" {
  description = "The value provided for var.publish"
  value       = var.publish
}

output "reserved_concurrent_executions" {
  description = "The value provided for var.reserved_concurrent_executions"
  value       = var.reserved_concurrent_executions
}

output "runtime" {
  description = "The value provided for var.runtime"
  value       = var.runtime
}

output "role_arn" {
  description = "The role created for the function, if one was not provided"
  value       = one(aws_iam_role.role)
}

output "s3_bucket" {
  description = "The value provided for var.s3_bucket"
  value       = var.s3_bucket
}

output "s3_key" {
  description = "The value provided for var.s3_key"
  value       = var.s3_key
}

output "s3_object_version" {
  description = "The value provided for var.s3_object_version"
  value       = var.s3_object_version
}

output "source_code_hash" {
  description = "The value provided for var.source_code_hash"
  value       = var.source_code_hash
}

output "tags" {
  description = "Tags assigned to the function"
  value = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}

output "timeout" {
  description = "The value provided for var.timeout"
  value       = var.timeout
}

output "tracing_config" {
  description = "The value provided for var.tracing_config"
  value       = var.tracing_config
}

output "vpc_config" {
  description = "The value provided for var.vpc_config"
  value       = var.vpc_config
}
