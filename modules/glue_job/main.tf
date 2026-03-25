###############################################
# GLUE ETL JOB
###############################################

resource "aws_glue_job" "etl" {
  name     = "${var.project_name}-glue-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://tg-etl-scripts/weather_etl.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"

    # Required by your ETL script
    "--RAW_BUCKET"     = var.raw_bucket_name
    "--RAW_PREFIX"     = "weather_raw/"
    "--CURATED_BUCKET" = var.curated_bucket_name
    "--CURATED_PREFIX" = "weather_curated/"
    "--DATABASE_NAME"  = var.glue_database_name
    "--TABLE_NAME"     = var.glue_table_name
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  tags = {
    Project = var.project_name
    Purpose = "glue-etl"
  }
}
