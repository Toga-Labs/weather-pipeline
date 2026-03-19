resource "aws_glue_crawler" "raw" {
  name          = "${var.project_name}-raw-crawler"
  role          = var.crawler_role_arn
  database_name = "${var.project_name}_raw_db"

  s3_target {
    path = "s3://${var.raw_bucket_name}/weather_raw/"
  }

  schedule = "cron(0/30 * * * ? *)" # runs every 30 minutes

  tags = {
    Project = var.project_name
    Purpose = "raw-crawler"
  }
}
