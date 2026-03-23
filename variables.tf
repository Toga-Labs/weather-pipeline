variable "project_name" {
  type        = string
  description = "Base name for all AWS resources."
}

variable "region" {
  type        = string
  description = "AWS region for deployment."
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


variable "city" {
  type        = string
  description = "City name used for weather API requests."
}

# Controls whether the Lambda module should be deployed.
# - false  = skip Lambda creation (used in the first pipeline apply)
# - true   = deploy Lambda (used after the ZIP is uploaded)
variable "deploy_lambda" {
  type    = bool
  default = false
}

variable "schedule_expression" {
  type        = string
  description = "EventBridge schedule expression (cron or rate)"
}
