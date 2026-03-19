###############################################
# PROJECT NAME
###############################################
variable "project_name" {
  type        = string
  description = "Name prefix for all project resources"
}

###############################################
# CITY FOR WEATHER API
###############################################
variable "city" {
  type        = string
  description = "City to fetch weather data for (e.g., 'Coventry,UK')"
}

###############################################
# WEATHER API KEY
###############################################
variable "weather_api_key" {
  type        = string
  sensitive   = true
  description = "Weather API key for Lambda ingestion"
}

###############################################
# RAW BUCKET NAME (for Lambda ingestion)
###############################################
variable "raw_bucket_name" {
  type        = string
  description = "S3 bucket where raw weather data is stored"
}

###############################################
# RAW PREFIX (folder inside raw bucket)
###############################################
variable "raw_prefix" {
  type        = string
  description = "Prefix/folder inside the raw bucket"
}

###############################################
# SCRIPTS BUCKET (Lambda ZIP + ETL script)
###############################################
variable "scripts_bucket" {
  type        = string
  description = "S3 bucket storing Lambda ZIP and ETL script"
}
