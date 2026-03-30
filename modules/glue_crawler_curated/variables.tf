variable "project_name" {
  type        = string
  description = "Project name for Glue CURATED crawler"
}

variable "crawler_role_arn" {
  type        = string
  description = "IAM role ARN for Glue crawler"
}

variable "curated_bucket_name" {
  type        = string
  description = "CURATED bucket name"
}

variable "database_name" {
  type        = string
  description = "Glue database name for CURATED zone"
}

