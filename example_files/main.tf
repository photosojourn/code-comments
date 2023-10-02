#todo:29/09/2023:Convert to Docker Imaged based packaging
module "package_dir" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v4.0.1"

  create_function = false

  runtime = "python3.8"
  source_path = [{
    path = "${path.module}/lambda"
  }]
}

#tfsec:ignore:aws-lambda-enable-tracing
module "lambda_function_from_package" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v4.0.1"

  create_package         = false
  layers                 = ["arn:aws:lambda:${var.region}:017000801446:layer:AWSLambdaPowertoolsPython:33"]
  local_existing_package = module.package_dir.local_filename

  function_name                     = "example-function"
  handler                           = "lambda.lambda_handler"
  runtime                           = "python3.8"
  timeout                           = 300
  cloudwatch_logs_retention_in_days = "3"
  environment_variables = {
    "ENABLE_XRAY" = "false"
  }
}
