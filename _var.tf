variable "aliases" {
  description = "Aliases to create for function code versions. Default version is $LATEST"
  type = list(object({
    name        = string
    description = optional(string)
  }))
  default = [
    {
      name        = "dev"
      description = "Development"
    },
    {
      name        = "pre-prod"
      description = "Pre-Production"
    },
    {
      name        = "prod"
      description = "Production"
    },
  ]
}

variable "architectures" {
  description = "Instruction set architecture for the function"
  type        = list(string)
  default     = null
}

variable "code_signing_config" {
  description = <<-EOF
    Code-Signing configuration to use for the function code.
    Allowed Publishers must be ARNs of AWS signing profiles
    Policies can be 'WARN' or 'ENFORCE'.
  EOF
  type = object({
    allowed_publishers = list(string)
    description        = optional(string)
    policy             = optional(string)
  })
  default = null
}

variable "dead_letter_config" {
  description = "Configurations for a dead letter queue for the function"
  type = object({
    target_arn = string
  })
  default = null
}

variable "description" {
  description = "A description to assign to the function"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment variables to set during function execution"
  type        = map(string)
  default     = null
}

variable "event_invoke_config" {
  description = "Asynchronous invocation configurations"
  type = list(object({
    destination_config = optional(object({
      on_failure = optional(list(string))
      on_success = optional(list(string))
    }))
    maximum_event_age_in_seconds = optional(number)
    maximum_retry_attempts       = optional(number)
    qualifier                    = optional(string)
  }))
  default = []
}

variable "event_source_mappings" {
  description = "Source mappings for Lambda to retrieve events from AWS services"
  type = list(object({
    batch_size                     = optional(number)
    bisect_batch_on_function_error = optional(bool)
    destination_configs = optional(list(object({
      on_failure = optional(list(object({
        destination_arn = string
      })))
    })))
    enabled                            = optional(bool)
    event_source_arn                   = optional(string)
    function_response_types            = optional(list(string))
    maximum_batching_window_in_seconds = optional(number)
    maximum_record_age_in_seconds      = optional(number)
    maximum_retry_attempts             = optional(number)
    parallelization_factor             = optional(number)
    queues                             = optional(list(string))
    self_managed_event_source = optional(object({
      endpoints = map(string)
    }))
    source_access_configurations = optional(list(object({
      type = string
      uri  = string
    })))
    starting_position           = optional(string)
    starting_position_timestamp = optional(string)
    topics                      = optional(list(string))
    tumbling_window_in_seconds  = optional(number)
  }))
  default = []
}

variable "file_system_config" {
  description = "Configurations to mount this function to a filesystem at runtime"
  type = object({
    arn              = string
    local_mount_path = string
  })
  default = null
}

variable "filename" {
  description = <<-EOF
    Path to a file on the local system that contains the function code
    Conflicts with var.image_uri, var.s3_bucket, var.s3_key, and var.s3_object_version
    EOF
  type        = string
  default     = null
}

variable "function_urls" {
  description = "HTTPS URLs to expose for the function or its qualifiers"
  type = list(object({
    authorization_type = string
    qualifier          = optional(string)
    cors = optional(object({
      allow_credentials = optional(bool)
      allow_headers     = optional(list(string))
      allow_methods     = optional(list(string))
      allow_origins     = optional(list(string))
      expose_headers    = optional(list(string))
      max_age           = optional(number)
    }))
  }))
  default = []
}

variable "handler" {
  description = "Function entrypoint into the code"
  type        = string
  default     = null
}

variable "image_config" {
  description = "Configurations that override config values from the container image Dockerfile"
  type = object({
    command           = optional(string)
    entry_point       = optional(string)
    working_directory = optional(string)
  })
  default = null
}

variable "image_uri" {
  description = <<-EOF
    ECR image URI containing the function's deployment package
    Conflicts with var.filename, var.s3_bucket, var.s3_key, and var.s3_object_version
    EOF
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of a KMS key used to encrypt environment variables"
  type        = string
  default     = null
}

variable "layers" {
  description = "Lambda layer version ARNs to attach to the function"
  type        = list(string)
  default     = null
}

variable "logging_enabled" {
  description = "Whether or not to create a Cloudwatch log group for this function and grant it the permission to upload logs"
  type        = bool
  default     = true
}

variable "memory_size" {
  description = "Memory in MB to assign to the function. Defaults to 128"
  type        = number
  default     = null
}

variable "name" {
  description = "The name to assign to resources created by this module"
  type        = string
}

variable "package_type" {
  description = "Zip or Image; defaults to Zip"
  type        = string
  default     = null
}

variable "permissions" {
  description = "Grants permission for external sources (S3, Cloudwatch, etc) to access the function"
  type = list(object({
    action                 = string
    event_source_token     = optional(string)
    function_url_auth_type = optional(string)
    principal              = string
    principal_org_id       = optional(string)
    qualifier              = optional(string)
    source_account         = optional(string)
    source_arn             = string
    statement_id           = optional(string)
    statement_id_prefix    = optional(string)
  }))
  default = []
}

variable "private_api_endpoint" {
  description = <<-EOF
    Private API Gateway endpoint to create for the function
    This enables access to the function via HTTPS without exposing it to the internet
    This will be accessible only via the VPC endpoints provided
  EOF
  type = object({
    authorization = optional(string)
    qualifiers    = optional(list(string))
    tags          = optional(map(string))
    vpce_ids      = list(string)
  })
  default = null
}

variable "provisioned_concurrency_config" {
  description = "Provisioned concurrency configurations for the function or some of its qualifiers"
  type = list(object({
    qualifier  = string
    executions = string
  }))
  default = []
}

variable "publish" {
  description = "Whether or not to publish changes as new function versions. Defaults to false"
  type        = bool
  default     = null
}

variable "reserved_concurrent_executions" {
  description = "How many times the function can be executed simultaneously. -1 = no limit, 0 = never execute"
  type        = number
  default     = null
}

variable "role_arn" {
  description = "A role (ARN) to assign to the function. If not provided, one will be created"
  type        = string
  default     = null
}

variable "role_policies" {
  description = "IAM policy documents to assign to the role created by the module. Conflicts with var.role"
  type = list(object({
    name        = optional(string)
    name_prefix = optional(string)
    policy      = string
  }))
  default = []
}

variable "runtime" {
  description = <<-EOF
    The runtime to assign to the function
    https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime
    EOF
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = <<-EOF
    An S3 bucket to retrieve the deployment package from
    Conflicts with var.filename and var.image_uri
    EOF
  type        = string
  default     = null
}

variable "s3_key" {
  description = <<-EOF
    A path within an S3 bucket at which to retrieve the deployment package
    Conflicts with var.filename and var.image_uri
    EOF
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = <<-EOF
    The version of an s3 object being used as a deployment package
    Conflicts with var.filename and var.image_uri
    EOF
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "A base64-encoded SHA256 hash of the package file specified with either var.filename or var.s3_key"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to the function"
  type        = map(string)
  default     = null
}

variable "timeout" {
  description = "The number of seconds to allow your function to attempt successful execution. Defaults to 3"
  type        = number
  default     = null
}

variable "tracing_config" {
  description = "Configurations for request tracing applied to the function"
  type = object({
    mode = string
  })
  default = null
}

variable "vpc_config" {
  description = <<-EOF
    Configurations to connect this function to a VPC
    create_security_group = true will make a dedicated security group to attach to the function (default true)
    security_group_ids will attach additional security groups to the function
    subnet_ids are the ids of the subnets that will contain the function's network interfaces
    EOF
  type = object({
    create_security_group = optional(bool)
    security_group_ids    = list(string)
    subnet_ids            = list(string)
  })
  default = null
}
