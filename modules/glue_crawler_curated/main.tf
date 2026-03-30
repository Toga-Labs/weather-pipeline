###############################################
# CURATED GLUE CRAWLER
###############################################

resource "aws_glue_crawler" "curated_crawler" {
  name          = "${var.project_name}-curated-crawler"
  role          = var.crawler_role_arn
  database_name = "${var.project_name}_curated_db"

  # IMPORTANT: Scan only the curated folder, not the bucket root
  s3_target {
    path = "s3://${var.curated_bucket_name}/weather_curated/"
  }


  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })

  # Optional schedule — remove if you want manual runs
  schedule = "cron(15 * * * ? *)" # runs at 15 minutes past each hour
}

