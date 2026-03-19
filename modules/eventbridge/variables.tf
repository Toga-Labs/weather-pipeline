variable "project_name" {
  type        = string
  description = "Project name for EventBridge rule"
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function to trigger"
}

variable "schedule_expression" {
  type        = string
  description = "EventBridge schedule expression (cron or rate)"
}
