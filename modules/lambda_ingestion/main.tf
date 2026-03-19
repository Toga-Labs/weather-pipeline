###############################################
# IAM — LAMBDA ROLE + POLICIES (SELF-CONTAINED)
###############################################

# Trust policy for Lambda
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role for Lambda (created inside module)
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Basic execution policy (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 access policy (read scripts + write raw data)
resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "${var.project_name}-lambda-s3-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::${var.scripts_bucket}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "arn:aws:s3:::${var.raw_bucket}/*"
      }
    ]
  })
}

###############################################
# LAMBDA FUNCTION
###############################################

resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion-lambda"

  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_handler.lambda_handler"
  runtime = "python3.11"

  # Lambda code stored in S3 (uploaded by CI pipeline)
  s3_bucket = var.scripts_bucket
  s3_key    = "lambda/lambda.zip"

  # Forces Terraform to redeploy Lambda when code changes
  source_code_hash = filebase64sha256("${path.module}/../../lambda_ingestion_code/placeholder.txt")

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      CITY            = var.city
      WEATHER_API_KEY = var.weather_api_key
      RAW_BUCKET      = var.raw_bucket
      RAW_PREFIX      = var.raw_prefix
    }
  }
}

###############################################
# CLOUDWATCH LOG GROUP
###############################################

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.ingestion.function_name}"
  retention_in_days = 14
}
