variable "project_name" {
  type        = string
  description = "Project name for Athena resources"
}

variable "athena_role_arn" {
  type        = string
  description = "IAM role ARN for Athena"
}

variable "athena_results_bucket_name" {
  type        = string
  description = "Bucket where Athena query results will be stored"
}

variable "curated_bucket_name" {
  type        = string
  description = "CURATED bucket name"
}
