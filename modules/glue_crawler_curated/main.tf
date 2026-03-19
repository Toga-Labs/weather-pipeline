resource "aws_glue_crawler" "curated" {
  name          = "${var.project_name}-curated-crawler"
  role          = var.crawler_role_arn
  database_name = "${var.project_name}_curated_db"

  s3_target {
    path = "s3://${var.curated_bucket_name}/weather_curated/"
  }

  schedule = "cron(15 * * * ? *)" # runs at 15 minutes past every hour

  tags = {
    Project = var.project_name
    Purpose = "curated-crawler"
  }
}
