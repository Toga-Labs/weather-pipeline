resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion-lambda"

  role    = var.lambda_role_arn
  handler = "lambda_handler.lambda_handler"
  runtime = "python3.11"

  s3_bucket = var.scripts_bucket
  s3_key    = "lambda/lambda.zip"

  # Ensures Lambda updates when code changes
  source_code_hash = filebase64sha256("${path.module}/../../lambda_ingestion_code/placeholder.txt")

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      CITY              = var.city
      RAW_BUCKET        = var.raw_bucket
      RAW_PREFIX        = var.raw_prefix
      API_KEY_SSM_PARAM = "/weather/api_key"
    }
  }
}
