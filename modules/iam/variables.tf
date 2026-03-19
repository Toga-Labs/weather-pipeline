variable "project_name" {
  type        = string
  description = "Project name for IAM resources"
}

variable "raw_bucket_arn" {
  type        = string
  description = "ARN of the RAW S3 bucket"
}

variable "curated_bucket_arn" {
  type        = string
  description = "ARN of the CURATED S3 bucket"
}

variable "athena_results_bucket_arn" {
  type        = string
  description = "ARN of the Athena results S3 bucket"

}
