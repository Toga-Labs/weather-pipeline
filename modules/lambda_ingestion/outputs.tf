output "lambda_function_name" {
  value       = aws_lambda_function.ingestion.function_name
  description = "Name of the deployed Lambda function."
}

output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "ARN of the IAM role used by the Lambda function."
}

