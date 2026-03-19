###############################################
# DATA SOURCES — USE EXISTING AWS RESOURCES
###############################################

# Existing IAM role for Lambda
data "aws_iam_role" "lambda_role" {
  name = "weather-pipeline-lambda-role"
}

# Existing S3 bucket for scripts
data "aws_s3_bucket" "scripts" {
  bucket = "weather-pipeline-scripts-tg"
}

# Existing S3 bucket for raw data
data "aws_s3_bucket" "raw" {
  bucket = "weather-pipeline-raw-data-tg"
}

###############################################
# LAMBDA FUNCTION
###############################################

resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion-lambda"

  role    = data.aws_iam_role.lambda_role.arn
  handler = "lambda_handler.lambda_handler"
  runtime = "python3.11"

  # Lambda code stored in S3 (uploaded by CI pipeline)
  s3_bucket = data.aws_s3_bucket.scripts.bucket
  s3_key    = "lambda/lambda.zip"

  # Forces Terraform to redeploy Lambda when code changes
  source_code_hash = filebase64sha256("${path.module}/../../lambda_ingestion_code/placeholder.txt")

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      WEATHER_API_KEY = var.weather_api_key
      RAW_BUCKET      = data.aws_s3_bucket.raw.bucket
      RAW_PREFIX      = var.raw_prefix
    }
  }
}

###############################################
# OPTIONAL: CLOUDWATCH LOG GROUP
###############################################

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.ingestion.function_name}"
  retention_in_days = 14
}
