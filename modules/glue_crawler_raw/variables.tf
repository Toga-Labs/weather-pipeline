variable "project_name" {
  type        = string
  description = "Project name for Glue RAW crawler"
}

variable "crawler_role_arn" {
  type        = string
  description = "IAM role ARN for Glue crawler"
}

variable "raw_bucket_name" {
  type        = string
  description = "RAW bucket name"
}

variable "database_name" {
  type        = string
  description = "Glue database name for RAW zone"
}

