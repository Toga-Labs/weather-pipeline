###############################################
# GLUE ETL JOB
###############################################

resource "aws_glue_job" "etl" {
  name     = "${var.project_name}-glue-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.raw_bucket_name}/scripts/etl_script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--raw_bucket_name"                  = var.raw_bucket_name
    "--curated_bucket_name"              = var.curated_bucket_name
    "--enable-metrics"                   = "true"
    "--enable-continuous-cloudwatch-log" = "true"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  tags = {
    Project = var.project_name
    Purpose = "glue-etl"
  }
}
