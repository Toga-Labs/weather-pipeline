# The name of your project. Used to name the Lambda function.
variable "project_name" {
  type        = string
  description = "Project name used to build the Lambda function name."
}

# The city your Lambda will fetch weather data for.
variable "city" {
  type        = string
  description = "City name used by the Lambda to request weather data."
}

# Folder/prefix inside the RAW bucket where Lambda stores JSON files.
variable "raw_prefix" {
  type        = string
  description = "S3 folder (prefix) inside the RAW bucket where Lambda saves raw data."
}

# The RAW bucket where Lambda writes the weather JSON files.
variable "raw_bucket" {
  type        = string
  description = "Name of the RAW S3 bucket where Lambda stores raw weather data."
}

# IAM role ARN created in the IAM module and passed into this module.
variable "lambda_role_arn" {
  type        = string
  description = "ARN of the IAM role that Lambda will use. Provided by the IAM module."
}

variable "api_key_ssm_param" {
  type = string
}
