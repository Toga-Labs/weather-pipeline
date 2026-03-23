data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/code"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "ingestion" {
  function_name = "${var.project_name}-ingestion"
  role          = var.lambda_role_arn
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      CITY       = var.city
      RAW_PREFIX = var.raw_prefix
      RAW_BUCKET = var.raw_bucket
    }
  }
}

output "lambda_arn" {
  value = aws_lambda_function.ingestion.arn
}
