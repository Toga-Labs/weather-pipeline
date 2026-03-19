output "lambda_function_name" {
  value = module.lambda_ingestion.lambda_function_name
}

output "lambda_role_arn" {
  value = module.lambda_ingestion.lambda_role_arn
}

output "lambda_log_group" {
  value = module.lambda_ingestion.lambda_log_group
}
