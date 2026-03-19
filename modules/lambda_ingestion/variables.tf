variable "project_name" {
  type        = string
  description = "Base name used to prefix all AWS resources created by this module."
}

variable "weather_api_key" {
  type        = string
  description = "API key used to authenticate requests to the external weather API."
}

variable "raw_prefix" {
  type        = string
  description = "S3 prefix (folder path) where raw ingested weather data will be stored."
}

variable "scripts_bucket" {
  type        = string
  description = "Name of the S3 bucket that stores Lambda code and ETL scripts."
}

variable "raw_bucket" {
  type        = string
  description = "Name of the S3 bucket where raw weather data will be written."
}

variable "city" {
  type        = string
  description = "City name used for weather API requests."
}
