###############################################
# EVENTBRIDGE RULE (SCHEDULE)
###############################################

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "${var.project_name}-lambda-schedule"
  schedule_expression = var.schedule_expression

  tags = {
    Project = var.project_name
    Purpose = "lambda-scheduler"
  }
}

###############################################
# EVENTBRIDGE TARGET (LAMBDA)
###############################################

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda-ingestion"
  arn       = var.lambda_function_arn
}

###############################################
# PERMISSION FOR EVENTBRIDGE TO INVOKE LAMBDA
###############################################

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}
