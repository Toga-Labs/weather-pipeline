output "lambda_function_name" {
  value = module.lambda_ingestion.lambda_function_name
}


# Lambda output must reference index [0] because the module uses count.
# When deploy_lambda=false in gitlab-ci-yml, count=0 → module list is empty → return null.
output "lambda_function_name" {
  value = var.deploy_lambda ? module.lambda_ingestion[0].lambda_function_name : null
}
