variable "project_name" {
  type        = string
  description = "Base name used to prefix all AWS resources created by this project."
}

variable "region" {
  type        = string
  description = "AWS region where all resources will be deployed."
}

variable "city" {
  type        = string
  description = "City name used for weather API requests and naming conventions."
}

variable "weather_api_key" {
  type        = string
  description = "API key used to authenticate requests to the external weather data provider."
}

variable "raw_prefix" {
  type        = string
  description = "S3 prefix (folder path) where raw ingested weather data will be stored."
}

variable "scripts_bucket" {
  type        = string
  description = "Name of the S3 bucket that stores Lambda code and ETL scripts.Flag to toggle infrastructure modules on or off"
}


variable "enable_infra" {
  description = "Controls whether infra modules (IAM, S3, Glue) are deployed"
  type        = bool
  default     = true
}
