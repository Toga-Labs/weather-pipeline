resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion-lambda"

  role    = var.lambda_role_arn
  handler = "lambda_handler.lambda_handler"
  runtime = "python3.11"

  s3_bucket = var.scripts_bucket
  s3_key    = "lambda/lambda.zip"

  # Forces Terraform to wait for the built lambda.zip before deploying Lambda
  source_code_hash = filebase64sha256("${path.module}/../../lambda_ingestion_code/placeholder.txt")

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      WEATHER_API_KEY = var.weather_api_key
      RAW_BUCKET      = var.raw_bucket_name
      RAW_PREFIX      = var.raw_prefix
    }
  }
}
