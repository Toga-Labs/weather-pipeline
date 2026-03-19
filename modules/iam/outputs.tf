output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "IAM role ARN for Lambda ingestion function"
}

output "glue_role_arn" {
  value       = aws_iam_role.glue_role.arn
  description = "IAM role ARN for Glue ETL job"
}

output "crawler_role_arn" {
  value       = aws_iam_role.crawler_role.arn
  description = "IAM role ARN for Glue crawlers"
}

output "athena_role_arn" {
  value       = aws_iam_role.athena_role.arn
  description = "IAM role ARN for Athena queries"
}
