module "my_lambda_function" {
  source = "../../"

  name     = "my-lambda-function"
  runtime  = "python3.9"
  handler  = "handler"
  filename = "${path.module}/function.dev.zip"
}
