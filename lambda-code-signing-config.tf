resource "aws_lambda_code_signing_config" "config" {
  count = var.code_signing_config != null ? 1 : 0

  description = var.code_signing_config.description

  allowed_publishers {
    signing_profile_version_arns = var.code_signing_config.allowed_publishers
  }

  dynamic "policies" {
    for_each = var.code_signing_config.policy == null ? [1] : []
    content {
      untrusted_artifact_on_deployment = var.code_signing_config.policy
    }
  }
}
