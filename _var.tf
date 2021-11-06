variable "architectures" {
  description = "Instruction set architecture for the function"
  type        = list(string)
  default     = null
}

variable "code_signing_config_arn" {
  description = "ARN of a code-signing configuration to use for the function code"
  type        = string
  default     = null
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

variable "file_system_config" {
  description = "Configurations to mount this function to an EFS at runtime"
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

variable "role" {
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
    A path within an S3 bucket to retrieve the deployment package from
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
  description = "Configurations to connect this function to a VPC"
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}
