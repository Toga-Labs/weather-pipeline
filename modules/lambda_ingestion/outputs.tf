output "lambda_function_name" {
  value       = aws_lambda_function.ingestion.function_name
  description = "Name of the deployed Lambda function."
}
