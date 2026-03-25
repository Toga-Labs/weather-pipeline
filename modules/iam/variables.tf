############################################################
# PROJECT NAME
############################################################

variable "project_name" {
  type        = string
  description = "Project name used to build IAM role names."
}

############################################################
# RAW BUCKET
############################################################

variable "raw_bucket" {
  type        = string
  description = "Name of the RAW S3 bucket where Lambda stores raw weather data."
}

variable "raw_bucket_arn" {
  type        = string
  description = "ARN of the RAW S3 bucket."
}

############################################################
# CURATED BUCKET
############################################################

variable "curated_bucket" {
  type        = string
  description = "Name of the CURATED S3 bucket where Glue writes transformed data."
}

variable "curated_bucket_arn" {
  type        = string
  description = "ARN of the CURATED S3 bucket."
}

############################################################
# SCRIPTS BUCKET
############################################################

variable "scripts_bucket" {
  type        = string
  description = "Name of the S3 bucket containing Glue ETL scripts."
}

variable "scripts_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket containing Glue ETL scripts."
}

############################################################
# TEMP BUCKET (Glue TempDir)
############################################################

variable "temp_bucket" {
  type        = string
  description = "Name of the TEMP S3 bucket used by Glue for TempDir."
}

variable "temp_bucket_arn" {
  type        = string
  description = "ARN of the TEMP S3 bucket used by Glue for TempDir."
}

############################################################
# ATHENA RESULTS BUCKET
############################################################

variable "athena_results_bucket" {
  type        = string
  description = "Name of the S3 bucket where Athena stores query results."
}

variable "athena_results_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket where Athena stores query results."
}

############################################################
# SSM PARAMETER (API KEY)
############################################################

variable "api_key_ssm_arn" {
  type        = string
  description = "ARN of the SSM parameter storing the API key."
}
