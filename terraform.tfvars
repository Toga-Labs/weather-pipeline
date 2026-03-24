project_name        = "weather-pipeline"
city                = "Coventry,UK"
raw_prefix          = "raw/"
region              = "eu-west-2"
raw_bucket          = "weather-pipeline-raw-data-tg"
schedule_expression = "rate(1 hour)"
scripts_bucket_arn  = "arn:aws:s3:::tg-etl-scripts"

