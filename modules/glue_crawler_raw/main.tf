###############################################
# RAW GLUE CRAWLER
###############################################

resource "aws_glue_crawler" "raw_crawler" {
  name          = "${var.project_name}-raw-crawler"
  role          = var.crawler_role_arn
  database_name = "${var.project_name}_raw_db"

  s3_target {
    path = "s3://${var.raw_bucket_name}/raw/"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  schedule = "cron(0 * * * ? *)" # every hour
}
