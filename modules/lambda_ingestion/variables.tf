variable "project_name" {
  type        = string
  description = "Project name for Lambda resources"
}

variable "lambda_role_arn" {
  type        = string
  description = "IAM role ARN for Lambda execution"
}

variable "raw_bucket_name" {
  type        = string
  description = "S3 bucket where raw weather data will be stored"
}


variable "city" {
  type        = string
  description = "City to fetch weather data for"
}


variable "project_name" {}
variable "lambda_role_arn" {}
variable "scripts_bucket" {}
variable "weather_api_key" {}
variable "raw_bucket" {}
variable "raw_prefix" {}
