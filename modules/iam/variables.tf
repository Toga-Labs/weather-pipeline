# The name of your project. Used to name IAM roles.
variable "project_name" {
  type        = string
  description = "Project name used to build IAM role names."
}



# The RAW bucket where Lambda writes the weather JSON files.
variable "raw_bucket" {
  type        = string
  description = "S3 RAW bucket where Lambda stores raw weather data."
}

# ARN version of the RAW bucket (needed for IAM policies).
variable "raw_bucket_arn" {
  type        = string
  description = "ARN of the RAW S3 bucket."
}

# ARN of the CURATED bucket (Glue job writes here).
variable "curated_bucket_arn" {
  type        = string
  description = "ARN of the CURATED S3 bucket."
}

# ARN of the Athena results bucket (Athena writes query results here).
variable "athena_results_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket where Athena stores query results."
}

variable "api_key_ssm_arn" {
  type        = string
  description = "ARN of the SSM parameter storing the API key"
}

variable "scripts_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket containing Glue ETL scripts"
}
