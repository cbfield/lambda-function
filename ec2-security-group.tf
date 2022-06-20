resource "aws_security_group" "security_group" {
  count = var.vpc_config != null && coalesce(try(var.vpc_config.create_security_group, true), true) ? 1 : 0

  name        = var.name
  description = "Manages access for the lambda function ${var.name}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = merge(var.tags, {
    "Managed By Terraform" = "true"
  })
}
