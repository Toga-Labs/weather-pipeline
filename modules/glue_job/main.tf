###############################################
# GLUE ETL JOB
###############################################

resource "aws_glue_job" "etl" {
  name     = "${var.project_name}-glue-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket}/weather_etl.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"

    # Required by ETL script
    "--JOB_NAME"       = "${var.project_name}-glue-etl-job"
    "--RAW_BUCKET"     = var.raw_bucket_name
    "--RAW_PREFIX"     = "raw/"
    "--CURATED_BUCKET" = var.curated_bucket_name
    "--CURATED_PREFIX" = "weather_curated/"
    "--DATABASE_NAME"  = "weather-pipeline_raw_db"
    "--TABLE_NAME"     = "curated"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  tags = {
    Project = var.project_name
    Purpose = "glue-etl"
  }
}

