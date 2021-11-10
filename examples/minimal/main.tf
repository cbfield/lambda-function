module "my_lambda_function" {
  source = "../../"

  name     = "my-lambda-function"
  runtime  = "python3.9"
  handler  = "handler"
  filename = "${path.module}/function.dev.zip"

  event_source_mappings = [
    {
      event_source_arn = "arn:aws:iam::111222333444:user/whatever"
    },
    {
      self_managed_event_source = {
        endpoints = { "oof" : "owie", "yikes" : "on-trikes" }
      }
    }
  ]
}
