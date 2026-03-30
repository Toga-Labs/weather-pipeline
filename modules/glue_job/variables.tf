variable "project_name" {
  type        = string
  description = "Project name used to name the Glue ETL job"
}

variable "glue_role_arn" {
  type        = string
  description = "IAM role ARN that the Glue ETL job will assume"
}

variable "raw_bucket_name" {
  type        = string
  description = "Name of the RAW S3 bucket where input data is stored"
}

variable "curated_bucket_name" {
  type        = string
  description = "Name of the CURATED S3 bucket where transformed data is written"
}

variable "scripts_bucket" {
  type        = string
  description = "S3 bucket containing the Glue ETL script"
}

variable "temp_bucket" {
  type        = string
  description = "S3 bucket used by Glue as the temporary directory (TempDir)"
}
