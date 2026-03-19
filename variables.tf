variable "project_name" {
  type        = string
  description = "Base name for all AWS resources."
}

variable "region" {
  type        = string
  description = "AWS region for deployment."
}

variable "weather_api_key" {
  type        = string
  description = "API key for external weather service."
}

variable "raw_prefix" {
  type        = string
  description = "S3 prefix for raw weather data."
}

variable "scripts_bucket" {
  type        = string
  description = "S3 bucket where Lambda code is uploaded by CI/CD."
}

variable "raw_bucket" {
  type        = string
  description = "S3 bucket where Lambda writes raw weather data."
}

variable "enable_infra" {
  type        = bool
  default     = true
  description = "Controls whether infra modules (IAM, S3, Glue) are deployed."
}

variable "city" {
  type        = string
  description = "City name used for weather API requests."
}
