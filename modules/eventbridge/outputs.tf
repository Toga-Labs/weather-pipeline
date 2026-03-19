output "eventbridge_rule_name" {
  value = aws_cloudwatch_event_rule.lambda_schedule.name
}
