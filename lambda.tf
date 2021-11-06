resource "aws_lambda_function" "function" {
  architectures                  = var.architectures
  code_signing_config_arn        = var.code_signing_config_arn
  description                    = var.description
  filename                       = var.filename
  function_name                  = var.name
  handler                        = var.handler
  image_uri                      = var.image_uri
  kms_key_arn                    = var.kms_key_arn
  layers                         = var.layers
  memory_size                    = var.memory_size
  package_type                   = var.package_type
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  role                           = coalesce(var.role, try(aws_iam_role.role.0.arn, null))
  runtime                        = var.runtime
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  s3_object_version              = var.s3_object_version
  source_code_hash               = var.source_code_hash
  timeout                        = var.timeout

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? toset([1]) : toset([])

    content {
      target_arn = var.dead_letter_config.target_arn
    }
  }

  environment {
    variables = var.environment
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? toset([1]) : toset([])

    content {
      arn              = var.file_system_config.arn
      local_mount_path = var.file_system_config.local_mount_path
    }
  }

  dynamic "image_config" {
    for_each = var.image_config != null ? toset([1]) : toset([])

    content {
      command           = var.image_config.command
      entry_point       = var.image_config.entry_point
      working_directory = var.image_config.working_directory
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config != null ? toset([1]) : toset([])

    content {
      mode = var.tracing_config.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? toset([1]) : toset([])

    content {
      security_group_ids = var.vpc_config.security_group_ids
      subnet_ids         = var.vpc_config.subnet_ids
    }
  }

  tags = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}
